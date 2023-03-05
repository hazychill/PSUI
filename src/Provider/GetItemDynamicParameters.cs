using System.Management.Automation;

namespace PSUI.Provider {
    internal class GetItemDynamicParameters {
        [Parameter]
        public int? UIProcessId { get; set; }
    }
}