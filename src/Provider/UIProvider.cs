using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Management.Automation.Provider;
using System.Text.RegularExpressions;
using System.Windows.Automation;

namespace PSUI.Provider {
    [CmdletProvider("UI", ProviderCapabilities.None)]
    public class UIProvider : NavigationCmdletProvider, IPropertyCmdletProvider {
        private const char itemSeparator = '\\';
        private const char altItemSeparator = '/';
        private const char runtimeIdElementSeparator = ',';

        private Regex pathValidationPattern;
        private AutomationElement root;

        public UIProvider() : base() {
            var patternStr = """
                ^(?x:
                (?i:ROOT)
                (?:[/\\]+(?<runtimeId>-?\d+(?:,-?\d+)*))*
                [/\\]*
                )$
                """;
            pathValidationPattern = new Regex(patternStr);

            root = AutomationElement.RootElement;
        }


        #region DriveCmdletProvider

        protected override Collection<PSDriveInfo> InitializeDefaultDrives() {
            var driveInfo = new PSDriveInfo("UI", ProviderInfo, "ROOT", "", null);
            var uiDriveInfo = new UIDriveInfo(driveInfo, UIDriveView.Raw);
            var collection = new Collection<PSDriveInfo>();
            collection.Add(uiDriveInfo);
            return collection;
        }

        protected override PSDriveInfo NewDrive(PSDriveInfo drive) {
            var dynamicParams = DynamicParameters as NewDriveDynamicParameters;
            UIDriveView view;
            if (dynamicParams is null) {
                view = UIDriveView.Raw;
            }
            else {
                view = dynamicParams.View;
            }
            return new UIDriveInfo(drive, view);
        }

        protected override object NewDriveDynamicParameters() {
            return new NewDriveDynamicParameters();
        }

        #endregion

        #region ItemCmdletProvider

        protected override void GetItem(string path) {
            var dparam = DynamicParameters as GetItemDynamicParameters;
            if ((dparam is not null) && (dparam.UIProcessId is not null)) {
                GetItemFromProcessId(dparam.UIProcessId.Value);
            }
            else {
                if (TryGetPathItem(path, out AutomationElement? pathItem, true)) {
                    WriteItemObject(pathItem, path, true);
                }
            }
        }

        protected override object GetItemDynamicParameters(string path) {
            return new GetItemDynamicParameters();
        }

        protected override bool IsValidPath(string path) {
            WriteDebug($"IsValidPath: {path}");
            var runtimeId = GetRuntimeIdPath(path);
            return runtimeId is not null;
        }

        protected override bool ItemExists(string path) {
            return TryGetPathItem(path, out AutomationElement _);
        }

        #endregion

        #region ContainerCmdletProvider

        protected override void GetChildItems(string path, bool recurse, uint depth) {
            if (TryGetPathItem(path, out AutomationElement? parent, true)) {
                GetChildItems(parent, path, recurse, depth);
            }
        }

        protected override void GetChildItems(string path, bool recurse) {
            base.GetChildItems(path, recurse, uint.MaxValue);
        }


        protected override object GetChildItemsDynamicParameters(string path, bool recurse) {
            return new GetChildItemsDynamicParameters();
        }

        protected override void GetChildNames(string path, ReturnContainers returnContainers) {
            var runtimeIdPath = GetRuntimeIdPath(path);
            if (runtimeIdPath is null) {
                WriteError(new ErrorRecord(
                    new ArgumentException(ErrorId.InvalidPathFormat, nameof(path)),
                    ErrorId.InvalidPathFormat,
                    ErrorCategory.ObjectNotFound,
                    null));
            }
            else {
                var parent = DigPath(root, runtimeIdPath);
                if (parent is null) {
                    WriteError(new ErrorRecord(
                        new ArgumentException(ErrorId.PathNotFound, nameof(path)),
                        ErrorId.PathNotFound,
                        ErrorCategory.ObjectNotFound,
                        null));
                }
                else {
                    var walker = GetTreeWalker();
                    var child = walker.GetFirstChild(parent);
                    if (child is not null) {
                        WriteChildItemObject(child, path, true);

                        while (true) {
                            child = walker.GetNextSibling(child);
                            if (child is not null) {
                                WriteChildItemObject(child, path, true);
                            }
                            else {
                                break;
                            }
                        }
                    }
                }
            }
        }

        protected override bool HasChildItems(string path) {
            var runtimeIdPath = GetRuntimeIdPath(path);
            if (runtimeIdPath is null) {
                return false;
            }

            var element = DigPath(root, runtimeIdPath);
            if (element is null) {
                return false;
            }

            var walker = GetTreeWalker();
            var child = walker.GetFirstChild(element);

            return child is not null;
        }

        #endregion

        #region NavigationCmdletProvider

        protected override bool IsItemContainer(string path) {
            return ItemExists(path);
        }

        #endregion

        #region IPropertyCmdletProvider

        public void ClearProperty(string path, Collection<string> propertyToClear){
            throw new NotImplementedException();
        }

        public object ClearPropertyDynamicParameters(string path, Collection<string> propertyToClear){
            throw new NotImplementedException();
        }

        public void GetProperty(string path, Collection<string> providerSpecificPickList){
            var runtimeIdPath = GetRuntimeIdPath(path);
            if (runtimeIdPath is null) {
                WriteError(new ErrorRecord(
                    new ArgumentException(ErrorId.InvalidPathFormat, nameof(path)),
                    ErrorId.InvalidPathFormat,
                    ErrorCategory.ObjectNotFound,
                    null));
            }
            else {
                var item = DigPath(root, runtimeIdPath);
                if (item is null) {
                    WriteError(new ErrorRecord(
                        new ArgumentException(ErrorId.PathNotFound, nameof(path)),
                        ErrorId.PathNotFound,
                        ErrorCategory.ObjectNotFound,
                        null));
                }
                else {
                    var propMap = AutomationPropertyTransformation.Map;

                    foreach (var propName in providerSpecificPickList) {
                        if (propMap.TryGetValue(propName, out AutomationProperty? prop)) {
                            var propVal = item.GetCurrentPropertyValue(prop);
                            if (propVal is not null) {
                                WritePropertyObject(propVal, path);
                            }
                        }
                    }
                }
            }
        }

        public object? GetPropertyDynamicParameters(string path, Collection<string> providerSpecificPickList) {
            return null;
        }

        public void SetProperty(string path, PSObject propertyValue) {
            throw new NotImplementedException();
        }

        public object SetPropertyDynamicParameters(string path, PSObject propertyValue) {
            throw new NotImplementedException();
        }

        #endregion

        #region Other

        private List<int[]>? GetRuntimeIdPath(string path) {
            var m = pathValidationPattern.Match(path);
            if (m.Success) {
                var runtimeIdList = new List<int[]>();
                foreach (Capture capture in m.Groups["runtimeId"].Captures) {
                    var val = capture.Value;
                    var idElements = val.Split(",");
                    var runtimeId = new int[idElements.Length];
                    for (var i = 0; i < idElements.Length; i++) {
                        if (int.TryParse(idElements[i], out int idElem)) {
                            runtimeId[i] = idElem;
                        }
                        else {
                            return null;
                        }
                    }
                    runtimeIdList.Add(runtimeId);
                }
                return runtimeIdList;
            }
            else {
                return null;
            }
        }

        private AutomationElement? DigPath(AutomationElement startElement, IEnumerable<int[]> runtimeIdPath) {
            var contextElement = startElement;
            foreach (var runtimeId in runtimeIdPath) {
                var cond = new PropertyCondition(AutomationElement.RuntimeIdProperty, runtimeId);
                var childElement = contextElement.FindFirst(TreeScope.Children, cond);
                if (childElement is not null) {
                    contextElement = childElement;
                }
                else {
                    return null;
                }
            }
            return contextElement;
        }

        private TreeWalker GetTreeWalker(Condition? condition = null) {
            var viewCondition = GetDriveViewCondition();
            if (viewCondition is not null) {
                return new TreeWalker(viewCondition);
            }
            else {
                return TreeWalker.RawViewWalker;
            }
        }

        private int[] GetRuntimeId(AutomationElement element) {
            var runtimeId = element.GetCurrentPropertyValue(AutomationElement.RuntimeIdProperty) as int[];
            if (runtimeId is null) {
                throw new Exception("RuntimeId is null");
            }
            return runtimeId;
        }

        private string WriteChildItemObject(AutomationElement element, string parentPath, bool writeName = false) {
            int[] runtimeId = GetRuntimeId(element);
            var childPath = MakePath(parentPath, runtimeId);
            if (writeName) {
                WriteItemObject(GetRuntimeIdString(runtimeId), childPath, true);
            }
            else {
                WriteItemObject(element, childPath, true);
            }
            return childPath;
        }

        private string GetRuntimeIdString(int[] runtimeId) {
            return string.Join(runtimeIdElementSeparator, runtimeId.Select(x => x.ToString()));
        }

        private string GetRuntimeIdString(AutomationElement element) {
            var runtimeId = GetRuntimeId(element);
            return GetRuntimeIdString(runtimeId);
        }

        
        private bool TryGetPathItem(string path, [NotNullWhen(true)] out AutomationElement? pathItem, bool writeError = false) {
            var runtimeIdPath = GetRuntimeIdPath(path);
            if (runtimeIdPath is null) {
                if (writeError) {
                    WriteError(
                        new ErrorRecord(null, ErrorId.InvalidPathFormat, ErrorCategory.InvalidArgument, null));
                }
                pathItem = null;
                return false;
            }

            pathItem = DigPath(AutomationElement.RootElement, runtimeIdPath);
            if (pathItem is null) {
                if (writeError) {
                    WriteError(
                        new ErrorRecord(null, ErrorId.PathNotFound, ErrorCategory.ObjectNotFound, null));
                }
                return false;
            }
            else {
                return true;
            }
        }

        private string MakePath(string path, int[] runtimeId) {
            var runtimeIdStr = GetRuntimeIdString(runtimeId);
            return MakePath(path, runtimeIdStr);
        }

        private string MakePath(string path, AutomationElement child) {
            var runtimeId = GetRuntimeId(child);
            return MakePath(path, runtimeId);
        }

         private void GetChildItems(AutomationElement parent, string path, bool recurse, uint depth) {
            var itemCondition = GetGetChildItemsCondition();
            var containerWalker = GetTreeWalker();

            parent = containerWalker.Normalize(parent);
            if (parent is null) {
                return;
            }

            var childItems = parent.FindAll(TreeScope.Children, itemCondition);
            foreach (AutomationElement childItem in childItems) {
                WriteChildItemObject(childItem, path);
            }

            if (recurse && depth > 0) {
                var containerCondition = GetDriveViewCondition() ?? Condition.TrueCondition;
                var childContainers = parent.FindAll(TreeScope.Children, containerCondition);
                foreach (AutomationElement childContainer in childContainers) {
                    var childContainerPath = MakePath(path, childContainer);
                    GetChildItems(childContainer, childContainerPath, recurse, depth - 1);
                }
            }
        }

        private Condition GetGetChildItemsCondition() {
            var conditions = new List<Condition>();

            var viewCondition = GetDriveViewCondition();
            if (viewCondition is not null) {
                conditions.Add(viewCondition);
            }

            var dparams = DynamicParameters as GetChildItemsDynamicParameters;
            if (dparams is not null) {
                if (dparams.UICondition is not null) {
                    conditions.AddRange(dparams.UICondition);
                }
                if (dparams.UIName is not null) {
                    conditions.Add(
                        new PropertyCondition(AutomationElement.NameProperty, dparams.UIName));
                }
                if (dparams.UIControlType is not null) {
                    conditions.Add(
                        new PropertyCondition(AutomationElement.ControlTypeProperty, dparams.UIControlType));
                }
                if (dparams.UIProcessId > 0) {
                    conditions.Add(
                        new PropertyCondition(AutomationElement.ProcessIdProperty, dparams.UIProcessId));
                }
            }

            if (conditions.Count == 0) {
                return Condition.TrueCondition;
            }
            else if (conditions.Count == 1) {
                return conditions[0];
            }
            else {
                return new AndCondition(conditions.ToArray());
            }
        }

        private Condition? GetDriveViewCondition() {
            var drive = PSDriveInfo as UIDriveInfo;
            if (drive is null) {
                return null;
            }

            switch (drive.View) {
                case UIDriveView.Raw:
                    return null;
                case UIDriveView.Control:
                    return new PropertyCondition(AutomationElement.IsContentElementProperty, true);
                case UIDriveView.Content:
                    return new PropertyCondition(AutomationElement.IsContentElementProperty, true);
                default:
                    ThrowTerminatingError(
                        new ErrorRecord(null, ErrorId.InvalidView, ErrorCategory.InvalidData, null));
                    return null;
            }
        }

        private void GetItemFromProcessId(int processId) {
            var process = Process.GetProcessById(processId);
            var handle = process.MainWindowHandle;
            var element = AutomationElement.FromHandle(handle);
            var path = GetPathFromRoot(element);
            WriteItemObject(element, path, true);
        }

        private string GetPathFromRoot(AutomationElement element) {
            var walker = GetTreeWalker();
            var runtimeIdPath = new List<string>();
            var rootRuntimeId = GetRuntimeIdString(AutomationElement.RootElement);
            var contextElem = element;
            var runtimeIdStr = GetRuntimeIdString(contextElem);
            while (!string.Equals(runtimeIdStr, rootRuntimeId, StringComparison.Ordinal)) {
                runtimeIdPath.Insert(0, runtimeIdStr);
                contextElem = walker.GetParent(contextElem);
                runtimeIdStr = GetRuntimeIdString(contextElem);
            }
            var path = string.Join(itemSeparator, runtimeIdPath);
            return $"ROOT{itemSeparator}{path}";
        }

        #endregion

    }
}