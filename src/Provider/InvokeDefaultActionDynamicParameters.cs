using System.Management.Automation;
using System.Windows.Automation;

namespace PSUI.Provider {
    internal sealed class InvokeDefaultActionDynamicParameters {
        [Parameter(Mandatory = true)]
        [ArgumentCompleter(typeof(AutomationPatternArgumentCompleter))]
        public AutomationPattern? UIPattern { get; set; }

        [Parameter(Mandatory = true)]
        public string? UIMethod { get; set; }

        [Parameter()]
        public object[]? UIArgument { get; set; }
    }
}