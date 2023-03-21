using System.Management.Automation;
using System.Windows.Automation;

namespace PSUI {
    [Cmdlet(VerbsCommon.New, "UICondition")]
    [OutputType(typeof(CommandOrigin))]
    public class NewUIConditionCommand : PSCmdlet {

        [Parameter(ParameterSetName = "property", Position = 0)]
        [ValidateNotNull]
        public AutomationProperty? Property { get; set; }

        [Parameter(ParameterSetName = "property", Position = 1)]
        public SwitchParameter Eq { get; set; }

        [Parameter(ParameterSetName = "property", Position = 2)]
        public object? PropertyValue { get; set; }

        [Parameter(ParameterSetName = "property", Position = 3)]
        public PropertyConditionFlags PropertyFlags { get; set; }

        [Parameter(ParameterSetName = "not", Position = 0)]
        public SwitchParameter Not { get; set; }

        [Parameter(ParameterSetName = "not", Position = 0)]
        [Parameter(ParameterSetName = "and", Position = 0)]
        [Parameter(ParameterSetName = "or", Position = 0)]
        [ValidateNotNull]
        public Condition? Condition { get; set; }

        [Parameter(ParameterSetName = "and", Position = 1)]
        public SwitchParameter And { get; set; }

        [Parameter(ParameterSetName = "or", Position = 1)]
        public SwitchParameter Or { get; set; }

        [Parameter(ParameterSetName = "and", Position = 2)]
        [Parameter(ParameterSetName = "or", Position = 2)]
        [ValidateNotNull]
        public Condition? AdditionalCondition { get; set; }

        [Parameter(ParameterSetName = "true", Position = 0)]
        public SwitchParameter True { get; set; }

        [Parameter(ParameterSetName = "false", Position = 0)]
        public SwitchParameter False { get; set; }

        protected override void EndProcessing() {
            Condition cond;
            WriteDebug($"NewUIConditionCommand.EndProcessing: ParameterSetName = {ParameterSetName}");
            switch (ParameterSetName) {
                case "property":
                    cond = GetPropertyCondition();
                    break;
                case "not":
                    cond = GetNotCondition();
                    break;
                case "and":
                    cond = GetAndCondition();
                    break;
                case "or":
                    cond = GetOrCondition();
                    break;
                case "true":
                    cond = GetTrueCondition();
                    break;
                case "false":
                    cond = GetFalseCondition();
                    break;
                default:
                    throw new Exception($"Unknown parameter set name: {ParameterSetName}");
            }
            
            WriteObject(cond);
        }

        private Condition GetPropertyCondition() {
            if (MyInvocation.BoundParameters.ContainsKey(nameof(PropertyFlags))) {
                return new PropertyCondition(Property, PropertyValue);
            }
            else {
                return new PropertyCondition(Property, PropertyValue, PropertyFlags);
            }
        }

        private Condition GetNotCondition() {
            return new NotCondition(Condition);
        }

        private Condition GetAndCondition() {
            return new AndCondition(Condition, AdditionalCondition);
        }

        private Condition GetOrCondition() {
            return new OrCondition(Condition, AdditionalCondition);
        }

        private Condition GetTrueCondition() {
            return Condition.TrueCondition;
        }

        private Condition GetFalseCondition() {
            return Condition.FalseCondition;
        }
    }
}