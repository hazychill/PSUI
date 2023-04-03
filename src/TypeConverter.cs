using System.Collections;
using System.Management.Automation;
using System.Management.Automation.Language;
using System.Text.RegularExpressions;
using System.Windows.Automation;

namespace PSUI;

public abstract class MapBasedTypeConverter<TFrom, TTo> : PSTypeConverter, IArgumentCompleter
        where TFrom : notnull
        where TTo : notnull {

    private Dictionary<TFrom, TTo> convertFromMapCaseSensitive;
    private Dictionary<string, TTo> convertFromMapCaseInsensitive;
    private Dictionary<TTo, TFrom> convertToMap;

    public bool IsStringFromType {
        get { return typeof(TFrom) == typeof(string); }
    }

    internal MapBasedTypeConverter() {
        convertFromMapCaseSensitive = new Dictionary<TFrom, TTo>();
        FillConvertFromMap(convertFromMapCaseSensitive);

        convertFromMapCaseInsensitive = new Dictionary<string, TTo>(StringComparer.OrdinalIgnoreCase);
        if (IsStringFromType) {
            foreach (var keyVal in convertFromMapCaseSensitive) {
                var key = keyVal.Key as string;
                if (key is not null) {
                    convertFromMapCaseInsensitive[key] = keyVal.Value;
                }
            }
        }

        convertToMap = new Dictionary<TTo, TFrom>();
        FillConvertToMap(convertToMap);
    }

    protected abstract void FillConvertFromMap(Dictionary<TFrom, TTo> convertFromMapCaseSensitive);

    protected abstract void FillConvertToMap(Dictionary<TTo, TFrom> convertToMap);

    public override bool CanConvertFrom(object sourceValue, Type destinationType) {
        if ((sourceValue is TFrom mapKey) && (destinationType == typeof(TTo))) {
            if (IsStringFromType) {
                var stringKey = mapKey as string;
                if (stringKey is not null) {
                    return convertFromMapCaseInsensitive.ContainsKey(stringKey);
                }
                else {
                    return false;
                }
            }
            else {
                return convertFromMapCaseSensitive.ContainsKey(mapKey);
            }
        }
        else {
            return false;
        }
    }

    public override bool CanConvertTo(object sourceValue, Type destinationType) {
        return (sourceValue is TTo typeValue) &&
            (destinationType == typeof(TFrom)) &&
            convertToMap.ContainsKey(typeValue);
    }

    public override object ConvertFrom(object sourceValue, Type destinationType, IFormatProvider formatProvider, bool ignoreCase) {
        if (convertFromMapCaseSensitive.Count == 0) {
            throw new NotSupportedException();
        }

        if (sourceValue is TFrom mapKey) {
            if ((destinationType is not null) && (destinationType.IsAssignableTo(typeof(TTo)))) {
                if (ignoreCase && IsStringFromType) {
                    var stringKey = mapKey as string;
                    if (stringKey is not null) {
                        if (convertFromMapCaseInsensitive.TryGetValue(stringKey, out TTo? mapVal)) {
                            return mapVal;
                        }
                        else {
                            throw new ArgumentException("source value cannot convert to destination type", nameof(sourceValue));
                        }
                    }
                    else {
                        throw new ArgumentException("source type not supported", nameof(sourceValue));
                    }
                }
                else {
                    if (convertFromMapCaseSensitive.TryGetValue(mapKey, out TTo? mapVal)) {
                        return mapVal;
                    }
                    else {
                        throw new ArgumentException("source value cannot convert to destination type", nameof(sourceValue));
                    }
                }

            }
            else {
                throw new ArgumentException("destination type not supported", nameof(destinationType));
            }
        }
        else {
            throw new ArgumentException("source type not supported", nameof(sourceValue));
        }
    }

    public override object ConvertTo(object sourceValue, Type destinationType, IFormatProvider formatProvider, bool ignoreCase) {
        if (convertToMap.Count == 0) {
            throw new NotSupportedException();
        }

        if (sourceValue is TTo mapKey) {
            if ((destinationType is not null) && (destinationType.IsAssignableTo(typeof(TFrom)))) {
                if (convertToMap.TryGetValue(mapKey, out TFrom? mapVal)) {
                    return mapVal;
                }
                else {
                    throw new ArgumentException("source value cannot convert to destination type", nameof(sourceValue));
                }
            }
            else {
                throw new ArgumentException("destination type not supported", nameof(destinationType));
            }
        }
        else {
            throw new ArgumentException("source type not supported", nameof(sourceValue));
        }
    }

    public string[] GetValidKeys() {
        if (IsStringFromType) {
            var keys = new string[convertFromMapCaseSensitive.Count];
            var stringKeyCollection = convertFromMapCaseSensitive.Keys as Dictionary<string, TTo>.KeyCollection;
            if (stringKeyCollection is not null) {
                stringKeyCollection.CopyTo(keys, 0);
                return keys;
            }
            else {
                return new string[0];
            }
        }
        else {
            return new string[0];
        }
    }

    public IEnumerable<CompletionResult> CompleteArgument(string commandName, string parameterName, string wordToComplete, CommandAst commandAst, IDictionary fakeBoundParameters) {
        var resultList = new List<CompletionResult>();
        if (IsStringFromType) {
            var stringKeys = convertFromMapCaseSensitive.Keys as IEnumerable<String>;
            if (stringKeys is not null) {
                var canditates = stringKeys
                    .Where(key => key.StartsWith(wordToComplete, StringComparison.OrdinalIgnoreCase))
                    .Select(key => new CompletionResult(key));
                resultList.AddRange(canditates);
            }
        }

        return resultList;
    }
}

public class ControlTypeTypeConverter : MapBasedTypeConverter<string, ControlType> {
    private static Dictionary<string, ControlType> convertFromMapCaseSensitive;
    private static Dictionary<string, ControlType> convertFromMapCaseInsensitive;
    private static Dictionary<ControlType, string> convertToMap;
    private static Lazy<ControlTypeTypeConverter> lazyInstance;

    static ControlTypeTypeConverter() {
        convertFromMapCaseSensitive = new Dictionary<string, ControlType>();
        convertFromMapCaseInsensitive = new Dictionary<string, ControlType>(StringComparer.OrdinalIgnoreCase);
        convertToMap = new Dictionary<ControlType, string>();

        var propFieldQuery = typeof(ControlType).GetFields().Where(x => x.FieldType == typeof(ControlType));
        foreach (var propField in propFieldQuery) {
            var name = propField.Name;
            var val = propField.GetValue(null) as ControlType;
            if (val is not null) {
                var programmaticName = val.ProgrammaticName;
                if (!string.IsNullOrEmpty(programmaticName)) {
                    convertFromMapCaseSensitive[programmaticName] = val;
                    convertFromMapCaseInsensitive[programmaticName] = val;
                    convertToMap[val] = programmaticName;
                }
                if (!string.IsNullOrEmpty(name)) {
                    convertFromMapCaseSensitive[name] = val;
                    convertFromMapCaseInsensitive[name] = val;
                    convertToMap[val] = name;
                }
            }
        }

        lazyInstance = new Lazy<ControlTypeTypeConverter>(() => new ControlTypeTypeConverter());
    }

    public static ControlTypeTypeConverter Instance {
        get { return lazyInstance.Value; }
    }

    protected override void FillConvertFromMap(Dictionary<string, ControlType> convertFromMapCaseSensitive) {
        foreach (var entry in ControlTypeTypeConverter.convertFromMapCaseSensitive) {
            convertFromMapCaseSensitive[entry.Key] = entry.Value;
        }
    }

    protected override void FillConvertToMap(Dictionary<ControlType, string> convertToMap) {
        foreach (var entry in ControlTypeTypeConverter.convertToMap) {
            convertToMap[entry.Key] = entry.Value;
        }
    }
}

public class ControlTypeArgumentCompleter : IArgumentCompleter {
    public IEnumerable<CompletionResult> CompleteArgument(string commandName, string parameterName, string wordToComplete, CommandAst commandAst, IDictionary fakeBoundParameters) {
        return ControlTypeTypeConverter.Instance.CompleteArgument(commandName, parameterName, wordToComplete, commandAst, fakeBoundParameters);
    }
}

public class AutomationPropertyTypeConverter : MapBasedTypeConverter<string, AutomationProperty> {
    private static Dictionary<string, AutomationProperty> convertFromMapCaseSensitive;
    private static Dictionary<string, AutomationProperty> convertFromMapCaseInsensitive;
    private static Lazy<AutomationPropertyTypeConverter> lazyInstance;

    static AutomationPropertyTypeConverter() {
        convertFromMapCaseSensitive = new Dictionary<string, AutomationProperty>();
        convertFromMapCaseInsensitive = new Dictionary<string, AutomationProperty>(StringComparer.OrdinalIgnoreCase);

        var elemType = typeof(AutomationElement);
        var propType = typeof(AutomationProperty);
        var typeNameReplacePattern = new Regex("Pattern$");
        var propNameReplacePattern = new Regex("Property$");

        var propFieldQuery = elemType.GetFields().Where(x => x.FieldType == propType);
        foreach (var propField in propFieldQuery) {
            var name = propField.Name;
            var val = propField.GetValue(null) as AutomationProperty;
            if (val is not null) {
                if (!string.IsNullOrEmpty(name)) {
                    name = propNameReplacePattern.Replace(name, string.Empty);
                    convertFromMapCaseSensitive[name] = val;
                    convertFromMapCaseInsensitive[name] = val;
                    var nameWithClass = $"{nameof(AutomationElement)}.{name}";
                    convertFromMapCaseSensitive[nameWithClass] = val;
                    convertFromMapCaseInsensitive[nameWithClass] = val;
                }
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
                convertFromMapCaseSensitive[x.Name] = x.Prop;
                convertFromMapCaseInsensitive[x.Name] = x.Prop;
            }
        }


        lazyInstance = new Lazy<AutomationPropertyTypeConverter>(() => new AutomationPropertyTypeConverter());
    }

    public static AutomationPropertyTypeConverter Instance {
        get { return lazyInstance.Value; }
    }

    protected override void FillConvertFromMap(Dictionary<string, AutomationProperty> convertFromMapCaseSensitive) {
        foreach (var entry in AutomationPropertyTypeConverter.convertFromMapCaseSensitive) {
            convertFromMapCaseSensitive[entry.Key] = entry.Value;
        }
    }

    protected override void FillConvertToMap(Dictionary<AutomationProperty, string> convertToMap) {
        // ConvertTo not supported
    }
}

public class AutomationPropertyArgumentCompleter : IArgumentCompleter {
    public IEnumerable<CompletionResult> CompleteArgument(string commandName, string parameterName, string wordToComplete, CommandAst commandAst, IDictionary fakeBoundParameters) {
        return AutomationPropertyTypeConverter.Instance.CompleteArgument(commandName, parameterName, wordToComplete, commandAst, fakeBoundParameters);
    }
}

public class AutomationPatternTypeConverter : MapBasedTypeConverter<string, AutomationPattern> {
    private static Dictionary<string, AutomationPattern> convertFromMapCaseSensitive;
    private static Dictionary<string, AutomationPattern> convertFromMapCaseInsensitive;
    private static Lazy<AutomationPatternTypeConverter> lazyInstance;

    static AutomationPatternTypeConverter() {
        convertFromMapCaseSensitive = new Dictionary<string, AutomationPattern>();
        convertFromMapCaseInsensitive = new Dictionary<string, AutomationPattern>(StringComparer.OrdinalIgnoreCase);

        var targetNamespace = typeof(InvokePattern).Namespace;
        var nameSuffix = "Pattern";
        var nameReplacePattern = new Regex("Pattern$");

        var patternQuery = System.Runtime.Loader.AssemblyLoadContext.Default.Assemblies
            .SelectMany(x => x.GetTypes())
            .Where(t => {
                if (!string.Equals(t.Namespace, targetNamespace, StringComparison.Ordinal)) {
                    return false;
                }
                if (!t.Name.EndsWith(nameSuffix)) {
                    return false;
                }
                var patternField = t.GetField(nameSuffix);
                return patternField?.FieldType == typeof(AutomationPattern);
            })
            .Select(t => t.GetField(nameSuffix));
        
        foreach (var patternField in patternQuery) {
            var name = patternField?.DeclaringType?.Name;
            var val = patternField?.GetValue(null) as AutomationPattern;
            if (!string.IsNullOrEmpty(name) && (val is not null)) {
                name = nameReplacePattern.Replace(name, string.Empty);
                convertFromMapCaseSensitive[name] = val;
                convertFromMapCaseInsensitive[name] = val;
            }
        }

        lazyInstance = new Lazy<AutomationPatternTypeConverter>(() => new AutomationPatternTypeConverter());
    }

    public static AutomationPatternTypeConverter Instance {
        get { return lazyInstance.Value; }
    }

    protected override void FillConvertFromMap(Dictionary<string, AutomationPattern> convertFromMapCaseSensitive) {
        foreach (var entry in AutomationPatternTypeConverter.convertFromMapCaseSensitive) {
            convertFromMapCaseSensitive[entry.Key] = entry.Value;
        }
    }

    protected override void FillConvertToMap(Dictionary<AutomationPattern, string> convertToMap) {
        // ConvertTo not supported
    }
}

public class AutomationPatternArgumentCompleter : IArgumentCompleter {
    public IEnumerable<CompletionResult> CompleteArgument(string commandName, string parameterName, string wordToComplete, CommandAst commandAst, IDictionary fakeBoundParameters) {
        return AutomationPatternTypeConverter.Instance.CompleteArgument(commandName, parameterName, wordToComplete, commandAst, fakeBoundParameters);
    }
}
