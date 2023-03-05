using System.Management.Automation;

namespace PSUI.Provider {
    public enum UIDriveView {
        Raw,
        Control,
        Content
    }

    public class UIDriveInfo : PSDriveInfo {
        public UIDriveView View { get; private set; }

        public UIDriveInfo(PSDriveInfo driveInfo, UIDriveView view) : base(driveInfo) {
            if (!Enum.IsDefined(view)) {
                throw new ArgumentException($"Value is not a member of UIDriverView.", nameof(view));
            }
            this.View = view;
        }

    }
}