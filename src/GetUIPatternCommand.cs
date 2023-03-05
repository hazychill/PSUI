using System.Management.Automation;
using System.Windows.Automation;

namespace PSUI {
    [Cmdlet(VerbsCommon.Get, "UIPattern", DefaultParameterSetName = "patternObj")]
    public class GetUIPatternCommand : PSCmdlet {
        [Parameter(Mandatory = true, ValueFromPipeline = true)]
        public AutomationElement[]? AutomationElement { get; set; }

        [Parameter(ParameterSetName = "patternObj", Position = 0)]
        [ArgumentToAutomationPatternTransformation]
        public AutomationPattern? Pattern { get; set; }

        [Parameter(ParameterSetName = "supportedPattern")]
        public SwitchParameter SupportedPattern { get; set; }

        protected override void ProcessRecord() {
            switch (ParameterSetName) {
                case "patternObj":
                    GetPatternObject();
                    break;
                case "supportedPattern":
                    GetSupportedPattern();
                    break;
            }
        }

        private void GetPatternObject() {
            if (AutomationElement is not null) {
                foreach (var elem in AutomationElement) {
                    if (elem is not null) {
                        if (elem.TryGetCurrentPattern(Pattern, out object patternObject)) {
                            WriteObject(patternObject);
                        }
                    }
                }
            }
        }

        private void GetSupportedPattern() {
            if (AutomationElement is not null) {
                foreach (var elem in AutomationElement) {
                    if (elem is not null) {
                        foreach (var pattern in elem.GetSupportedPatterns()) {
                            if (pattern is not null) {
                                WriteObject(pattern);
                            }
                        }
                    }
                }
            }
        }

    }
}