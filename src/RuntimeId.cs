using System.Windows.Automation;

namespace PSUI;

public struct RuntimeId {
    public static readonly char ItemIdElementSeparator = '_';

    public int[] Value { get; private set; }

    public RuntimeId(int[] value) {
        Value = value;
    }

    public RuntimeId(AutomationElement element) {
        var val = element.GetCurrentPropertyValue(AutomationElement.RuntimeIdProperty) as int[];
        if (val is null) {
            throw new ArgumentException("RuntimeId is null", nameof(element));
        }
        Value = val;
    }

    public RuntimeId(string itemId) {
        var idElems = itemId.Split(ItemIdElementSeparator);
        Value = new int[idElems.Length];
        for (var i = 0; i < idElems.Length; i++) {
            if (int.TryParse(idElems[i], out int intVal)) {
                Value[i] = intVal;
            }
            else {
                throw new ArgumentException("invalid item ID format", nameof(itemId));
            }
        }
    }

    public string ToItemId() {
        return string.Join(
            ItemIdElementSeparator,
            Value.Select(x => x.ToString()));
    }

    public static implicit operator int[](RuntimeId rid) => rid.Value;
    public static implicit operator RuntimeId(int[] rid) => new RuntimeId(rid);
}