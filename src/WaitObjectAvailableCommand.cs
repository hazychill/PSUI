using System.Collections.ObjectModel;
using System.Management.Automation;

namespace PSUI {
    [Cmdlet(VerbsLifecycle.Wait, "ObjectAvailable")]
    public class WaitObjectAvailableCommand : PSCmdlet {
        [Parameter(Mandatory = true, Position = 0)]
        [ValidateNotNull]
        public ScriptBlock? ScriptBlock { get; set; }

        [Parameter]
        public TimeSpan TimeOut { get; set; } = TimeSpan.FromSeconds(10);

        [Parameter]
        public TimeSpan Interval { get; set; } = TimeSpan.FromSeconds(1);

        protected override void EndProcessing() {
            var start = DateTime.Now;
            Exception? lastError = null;
            while (true) {
                try {
                    var outObjects = ScriptBlock?.Invoke();
                    List<PSObject> positiveResults = new List<PSObject>();
                    if (HasPositiveResult(outObjects, positiveResults)) {
                        WriteObject(positiveResults, true);
                        return;
                    }
                }
                catch (Exception e) {
                    lastError = e;
                }

                Thread.Sleep(Interval);

                if (DateTime.Now - start > TimeOut) {
                    throw new TimeoutException("wait timed out", lastError);
                }
            }
        }

        private bool HasPositiveResult(Collection<PSObject>? outObjects, List<PSObject> positiveResults){
            if (outObjects is null) {
                return false;
            }

            var hasPositiveResult = false;
            foreach (var outObj in outObjects) {
                if (IsPositiveValue(outObj)) {
                    hasPositiveResult = true;
                    positiveResults.Add(outObj);
                }
            }

            return hasPositiveResult;
        }

        private bool IsPositiveValue(PSObject outObj) {
            if (outObj is null) {
                return false;
            }
            var baseObj = outObj.BaseObject;
            if (baseObj is null) {
                return false;
            }
            if ((baseObj is bool x) && (x == false)) {
                return false;
            }
            if (baseObj is Exception) {
                return false;
            }
            if (baseObj is ErrorRecord) {
                return false;
            }
            return true;
        }
    }
}