using System.Management.Automation;

namespace PSUI.Provider {
    internal sealed class NewDriveDynamicParameters {
        [Parameter]
        public UIDriveView UIView { get; set; }
    }
}