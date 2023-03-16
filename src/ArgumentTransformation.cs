using System.Collections.ObjectModel;
using System.Management.Automation;
using System.Runtime.Loader;
using System.Text.RegularExpressions;
using System.Windows.Automation;

namespace PSUI {

    internal static class AutomationPropertyTransformation {
        private static Dictionary<String, AutomationProperty> transformMap;
        
        static AutomationPropertyTransformation() {
            transformMap = new Dictionary<string, AutomationProperty>(StringComparer.OrdinalIgnoreCase);

            var typeNameReplacePattern = new Regex("Pattern$");
            var propNameReplacePattern = new Regex("Property$");

            var elemType = typeof(AutomationElement);
            var propType = typeof(AutomationProperty);
            var propFieldQuery = elemType.GetFields().Where(x => x.FieldType == propType);
            foreach (var propField in propFieldQuery) {
                var name = propNameReplacePattern.Replace(propField.Name, string.Empty);
                var val = propField.GetValue(null) as AutomationProperty;
                if (val is not null) {
                    transformMap.Add(name, val);
                }
            }

            var patternPropFields = elemType.Assembly.GetTypes()
                .Where(t =>
                    string.Equals(t.Namespace, elemType.Namespace, StringComparison.Ordinal) &&
                    t.Name.EndsWith("Pattern", StringComparison.Ordinal))
                .SelectMany(t => t.GetFields()
                    .Where(f =>
                        f.Name.EndsWith("Property", StringComparison.Ordinal) &&
                        f.FieldType == propType)
                    .Select(f => new {
                        Name = $"{typeNameReplacePattern.Replace(t.Name, string.Empty)}.{propNameReplacePattern.Replace(f.Name, string.Empty)}",
                        Prop = f.GetValue(null) as AutomationProperty
                    }));
            foreach (var x in patternPropFields) {
                if (x.Prop is not null) {
                    transformMap.Add(x.Name, x.Prop);
                }
            }
        }

        public static ReadOnlyDictionary<String, AutomationProperty> Map => new ReadOnlyDictionary<string, AutomationProperty>(transformMap);

    }
    
    public class ArgumentToAutomationPropertyTransformationAttribute : ArgumentTransformationAttribute {

        public override object Transform(EngineIntrinsics engineIntrinsics, object inputData) {
            if (inputData is string propName) {
                if (AutomationPropertyTransformation.Map.TryGetValue(propName, out AutomationProperty? prop)) {
                    return prop;
                }
            }
            return inputData;
        }

    }

    internal static class AutomationPatternTransformation {
        private static Dictionary<String, AutomationPattern> transformMap;
        
        static AutomationPatternTransformation() {
            transformMap = new Dictionary<string, AutomationPattern>(StringComparer.OrdinalIgnoreCase);

            var targetNamespace = typeof(InvokePattern).Namespace;

            var patternQuery = System.Runtime.Loader.AssemblyLoadContext.Default.Assemblies
                .SelectMany(x => x.GetTypes())
                .Where(t => {
                    if (!string.Equals(t.Namespace, targetNamespace, StringComparison.Ordinal)) {
                        return false;
                    }
                    if (!t.Name.EndsWith("Pattern")) {
                        return false;
                    }
                    var patternField = t.GetField("Pattern");
                    return patternField?.FieldType == typeof(AutomationPattern);
                })
                .Select(t => t.GetField("Pattern"));

            foreach (var patternField in patternQuery) {
                var patternName = patternField?.DeclaringType?.Name.Replace("Pattern", "");
                var patternVal = patternField?.GetValue(null) as AutomationPattern;
                if (!string.IsNullOrEmpty(patternName) && (patternVal is not null)) {
                    transformMap.Add(patternName, patternVal);
                }
            }
        }

        public static ReadOnlyDictionary<String, AutomationPattern> Map => new ReadOnlyDictionary<string, AutomationPattern>(transformMap);

    }

    public class ArgumentToAutomationPatternTransformationAttribute : ArgumentTransformationAttribute {

        public override object Transform(EngineIntrinsics engineIntrinsics, object inputData) {
            if (inputData is string propName) {
                if (AutomationPatternTransformation.Map.TryGetValue(propName, out AutomationPattern? prop)) {
                    return prop;
                }
            }
            return inputData;
        }

    }

    public static class ControlTypeTransformation {
        private static Dictionary<String, ControlType> transformMap;

        static ControlTypeTransformation() {
            transformMap = new Dictionary<String, ControlType>(StringComparer.OrdinalIgnoreCase);

            var propFieldQuery = typeof(ControlType).GetFields().Where(x => x.FieldType == typeof(ControlType));
            foreach (var propField in propFieldQuery) {
                var name = propField.Name;
                var val = propField.GetValue(null) as ControlType;
                if (val is not null) {
                    transformMap.Add(name, val);
                }
            }
        }
         public static ReadOnlyDictionary<String, ControlType> Map => new ReadOnlyDictionary<string, ControlType>(transformMap);
    }

    public class ArgumentToControlTypeTransformationAttribute : ArgumentTransformationAttribute {

        public override object Transform(EngineIntrinsics engineIntrinsics, object inputData) {
            if (inputData is string typeName) {
                if (ControlTypeTransformation.Map.TryGetValue(typeName, out ControlType? type)) {
                    return type;
                }
            }
            return inputData;
        }

    }
}