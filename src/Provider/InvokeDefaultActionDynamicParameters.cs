using System.Management.Automation;
using System.Windows.Automation;

namespace PSUI.Provider {
    internal sealed class InvokeDefaultActionDynamicParameters {
        [Parameter(Mandatory = true)]
        public AutomationPattern? As { get; set; }

        [Parameter(Mandatory = true)]
        public string? Method { get; set; }

        [Parameter()]
        public object[]? Argument { get; set; }
    }
}