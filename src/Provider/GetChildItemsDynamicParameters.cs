using System.Management.Automation;
using System.Windows.Automation;

namespace PSUI.Provider {
    internal class GetChildItemsDynamicParameters {
        [Parameter]
        [ValidateNotNull]
        public string? UIName { get; set; }

        [Parameter]
        public ControlType? UIControlType { get; set; }

        [Parameter]
        public int UIProcessId { get; set; }

        [Parameter]
        [ValidateNotNull]
        public Condition[]? UICondition { get; set; }

        public GetChildItemsDynamicParameters() {
        }
    }
}