Describe 'AutomationPropertyTypeConverter' {
    BeforeDiscovery {
        Add-Type -AssemblyName 'UIAutomationClient'
    }

    BeforeAll {
        $ErrorActionPreference = 'Stop'
        . (Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath 'Util.ps1')
        Import-PSUIModule
        $converter = [PSUI.AutomationPropertyTypeConverter]::Instance
    }

    Context 'ConvertFrom' {
        It 'Converts string name to AutomationProperty' -ForEach @(
            @{ Name = 'AcceleratorKey'; Expected = [System.Windows.Automation.AutomationElement]::AcceleratorKeyProperty }
            @{ Name = 'AccessKey'; Expected = [System.Windows.Automation.AutomationElement]::AccessKeyProperty }
            @{ Name = 'AutomationId'; Expected = [System.Windows.Automation.AutomationElement]::AutomationIdProperty }
            @{ Name = 'BoundingRectangle'; Expected = [System.Windows.Automation.AutomationElement]::BoundingRectangleProperty }
            @{ Name = 'ClassName'; Expected = [System.Windows.Automation.AutomationElement]::ClassNameProperty }
            @{ Name = 'ClickablePoint'; Expected = [System.Windows.Automation.AutomationElement]::ClickablePointProperty }
            @{ Name = 'ControlType'; Expected = [System.Windows.Automation.AutomationElement]::ControlTypeProperty }
            @{ Name = 'Culture'; Expected = [System.Windows.Automation.AutomationElement]::CultureProperty }
            @{ Name = 'FrameworkId'; Expected = [System.Windows.Automation.AutomationElement]::FrameworkIdProperty }
            @{ Name = 'HasKeyboardFocus'; Expected = [System.Windows.Automation.AutomationElement]::HasKeyboardFocusProperty }
            @{ Name = 'HeadingLevel'; Expected = [System.Windows.Automation.AutomationElement]::HeadingLevelProperty }
            @{ Name = 'HelpText'; Expected = [System.Windows.Automation.AutomationElement]::HelpTextProperty }
            @{ Name = 'IsContentElement'; Expected = [System.Windows.Automation.AutomationElement]::IsContentElementProperty }
            @{ Name = 'IsControlElement'; Expected = [System.Windows.Automation.AutomationElement]::IsControlElementProperty }
            @{ Name = 'IsDialog'; Expected = [System.Windows.Automation.AutomationElement]::IsDialogProperty }
            @{ Name = 'IsDockPatternAvailable'; Expected = [System.Windows.Automation.AutomationElement]::IsDockPatternAvailableProperty }
            @{ Name = 'IsEnabled'; Expected = [System.Windows.Automation.AutomationElement]::IsEnabledProperty }
            @{ Name = 'IsExpandCollapsePatternAvailable'; Expected = [System.Windows.Automation.AutomationElement]::IsExpandCollapsePatternAvailableProperty }
            @{ Name = 'IsGridItemPatternAvailable'; Expected = [System.Windows.Automation.AutomationElement]::IsGridItemPatternAvailableProperty }
            @{ Name = 'IsGridPatternAvailable'; Expected = [System.Windows.Automation.AutomationElement]::IsGridPatternAvailableProperty }
            @{ Name = 'IsInvokePatternAvailable'; Expected = [System.Windows.Automation.AutomationElement]::IsInvokePatternAvailableProperty }
            @{ Name = 'IsItemContainerPatternAvailable'; Expected = [System.Windows.Automation.AutomationElement]::IsItemContainerPatternAvailableProperty }
            @{ Name = 'IsKeyboardFocusable'; Expected = [System.Windows.Automation.AutomationElement]::IsKeyboardFocusableProperty }
            @{ Name = 'IsMultipleViewPatternAvailable'; Expected = [System.Windows.Automation.AutomationElement]::IsMultipleViewPatternAvailableProperty }
            @{ Name = 'IsOffscreen'; Expected = [System.Windows.Automation.AutomationElement]::IsOffscreenProperty }
            @{ Name = 'IsPassword'; Expected = [System.Windows.Automation.AutomationElement]::IsPasswordProperty }
            @{ Name = 'IsRangeValuePatternAvailable'; Expected = [System.Windows.Automation.AutomationElement]::IsRangeValuePatternAvailableProperty }
            @{ Name = 'IsRequiredForForm'; Expected = [System.Windows.Automation.AutomationElement]::IsRequiredForFormProperty }
            @{ Name = 'IsScrollItemPatternAvailable'; Expected = [System.Windows.Automation.AutomationElement]::IsScrollItemPatternAvailableProperty }
            @{ Name = 'IsScrollPatternAvailable'; Expected = [System.Windows.Automation.AutomationElement]::IsScrollPatternAvailableProperty }
            @{ Name = 'IsSelectionItemPatternAvailable'; Expected = [System.Windows.Automation.AutomationElement]::IsSelectionItemPatternAvailableProperty }
            @{ Name = 'IsSelectionPatternAvailable'; Expected = [System.Windows.Automation.AutomationElement]::IsSelectionPatternAvailableProperty }
            @{ Name = 'IsSynchronizedInputPatternAvailable'; Expected = [System.Windows.Automation.AutomationElement]::IsSynchronizedInputPatternAvailableProperty }
            @{ Name = 'IsTableItemPatternAvailable'; Expected = [System.Windows.Automation.AutomationElement]::IsTableItemPatternAvailableProperty }
            @{ Name = 'IsTablePatternAvailable'; Expected = [System.Windows.Automation.AutomationElement]::IsTablePatternAvailableProperty }
            @{ Name = 'IsTextPatternAvailable'; Expected = [System.Windows.Automation.AutomationElement]::IsTextPatternAvailableProperty }
            @{ Name = 'IsTogglePatternAvailable'; Expected = [System.Windows.Automation.AutomationElement]::IsTogglePatternAvailableProperty }
            @{ Name = 'IsTransformPatternAvailable'; Expected = [System.Windows.Automation.AutomationElement]::IsTransformPatternAvailableProperty }
            @{ Name = 'IsValuePatternAvailable'; Expected = [System.Windows.Automation.AutomationElement]::IsValuePatternAvailableProperty }
            @{ Name = 'IsVirtualizedItemPatternAvailable'; Expected = [System.Windows.Automation.AutomationElement]::IsVirtualizedItemPatternAvailableProperty }
            @{ Name = 'IsWindowPatternAvailable'; Expected = [System.Windows.Automation.AutomationElement]::IsWindowPatternAvailableProperty }
            @{ Name = 'ItemStatus'; Expected = [System.Windows.Automation.AutomationElement]::ItemStatusProperty }
            @{ Name = 'ItemType'; Expected = [System.Windows.Automation.AutomationElement]::ItemTypeProperty }
            @{ Name = 'LabeledBy'; Expected = [System.Windows.Automation.AutomationElement]::LabeledByProperty }
            @{ Name = 'LocalizedControlType'; Expected = [System.Windows.Automation.AutomationElement]::LocalizedControlTypeProperty }
            @{ Name = 'Name'; Expected = [System.Windows.Automation.AutomationElement]::NameProperty }
            @{ Name = 'NativeWindowHandle'; Expected = [System.Windows.Automation.AutomationElement]::NativeWindowHandleProperty }
            @{ Name = 'Orientation'; Expected = [System.Windows.Automation.AutomationElement]::OrientationProperty }
            @{ Name = 'PositionInSet'; Expected = [System.Windows.Automation.AutomationElement]::PositionInSetProperty }
            @{ Name = 'ProcessId'; Expected = [System.Windows.Automation.AutomationElement]::ProcessIdProperty }
            @{ Name = 'RuntimeId'; Expected = [System.Windows.Automation.AutomationElement]::RuntimeIdProperty }
            @{ Name = 'SizeOfSet'; Expected = [System.Windows.Automation.AutomationElement]::SizeOfSetProperty }
        ) {
            $converter.CanConvertFrom($Name, ([System.Windows.Automation.AutomationProperty])) | Should -Be $true
            $converter.ConvertFrom($Name, ([System.Windows.Automation.AutomationProperty]), $null, $false) | Should -Be $Expected
            $converter.ConvertFrom($Name, ([System.Windows.Automation.AutomationProperty]), $null, $true) | Should -Be $Expected

            # with `AutomationElement' prefix
            $prefixedName = "AutomationElement.${Name}"
            $converter.CanConvertFrom($prefixedName, ([System.Windows.Automation.AutomationProperty])) | Should -Be $true
            $converter.ConvertFrom($prefixedName, ([System.Windows.Automation.AutomationProperty]), $null, $false) | Should -Be $Expected
            $converter.ConvertFrom($prefixedName, ([System.Windows.Automation.AutomationProperty]), $null, $true) | Should -Be $Expected
        }

        It 'Converts string name to AutomationProperty (ignoreCase=$true)' -ForEach @(
            @{ Name = 'IscONtroLelEment'; Expected = [System.Windows.Automation.AutomationElement]::IsControlElementProperty }
            @{ Name = 'conTroltypE'; Expected = [System.Windows.Automation.AutomationElement]::ControlTypeProperty }
            @{ Name = 'IsconTentEleMent'; Expected = [System.Windows.Automation.AutomationElement]::IsContentElementProperty }
            @{ Name = 'LABeLEDBY'; Expected = [System.Windows.Automation.AutomationElement]::LabeledByProperty }
            @{ Name = 'nAtIVEWindowHANDlE'; Expected = [System.Windows.Automation.AutomationElement]::NativeWindowHandleProperty }
            @{ Name = 'aUToMAtIoniD'; Expected = [System.Windows.Automation.AutomationElement]::AutomationIdProperty }
            @{ Name = 'ItEMType'; Expected = [System.Windows.Automation.AutomationElement]::ItemTypeProperty }
            @{ Name = 'ispassworD'; Expected = [System.Windows.Automation.AutomationElement]::IsPasswordProperty }
            @{ Name = 'LOcALizedcOntRoltypE'; Expected = [System.Windows.Automation.AutomationElement]::LocalizedControlTypeProperty }
            @{ Name = 'NaME'; Expected = [System.Windows.Automation.AutomationElement]::NameProperty }
            @{ Name = 'AcCeleratOrkEy'; Expected = [System.Windows.Automation.AutomationElement]::AcceleratorKeyProperty }
            @{ Name = 'AcCESskEy'; Expected = [System.Windows.Automation.AutomationElement]::AccessKeyProperty }
            @{ Name = 'HaskeYBoArDfOcUS'; Expected = [System.Windows.Automation.AutomationElement]::HasKeyboardFocusProperty }
            @{ Name = 'isKeybOarDFoCuSABLE'; Expected = [System.Windows.Automation.AutomationElement]::IsKeyboardFocusableProperty }
            @{ Name = 'isENAbLeD'; Expected = [System.Windows.Automation.AutomationElement]::IsEnabledProperty }
            @{ Name = 'boUNdIngreCTaNGlE'; Expected = [System.Windows.Automation.AutomationElement]::BoundingRectangleProperty }
            @{ Name = 'prOcESSid'; Expected = [System.Windows.Automation.AutomationElement]::ProcessIdProperty }
            @{ Name = 'runtimEid'; Expected = [System.Windows.Automation.AutomationElement]::RuntimeIdProperty }
            @{ Name = 'cLaSsNAME'; Expected = [System.Windows.Automation.AutomationElement]::ClassNameProperty }
            @{ Name = 'HELPTeXT'; Expected = [System.Windows.Automation.AutomationElement]::HelpTextProperty }
            @{ Name = 'cLICkabLepoINT'; Expected = [System.Windows.Automation.AutomationElement]::ClickablePointProperty }
            @{ Name = 'CULTURe'; Expected = [System.Windows.Automation.AutomationElement]::CultureProperty }
            @{ Name = 'ISOFFSCreEN'; Expected = [System.Windows.Automation.AutomationElement]::IsOffscreenProperty }
            @{ Name = 'ORiEnTATion'; Expected = [System.Windows.Automation.AutomationElement]::OrientationProperty }
            @{ Name = 'FRAmeWOrKid'; Expected = [System.Windows.Automation.AutomationElement]::FrameworkIdProperty }
            @{ Name = 'iSrEqUIReDfORfOrm'; Expected = [System.Windows.Automation.AutomationElement]::IsRequiredForFormProperty }
            @{ Name = 'IteMsTatUs'; Expected = [System.Windows.Automation.AutomationElement]::ItemStatusProperty }
            @{ Name = 'siZeOFseT'; Expected = [System.Windows.Automation.AutomationElement]::SizeOfSetProperty }
            @{ Name = 'PositioNInSET'; Expected = [System.Windows.Automation.AutomationElement]::PositionInSetProperty }
            @{ Name = 'HeaDiNgLevEL'; Expected = [System.Windows.Automation.AutomationElement]::HeadingLevelProperty }
            @{ Name = 'ISdIAloG'; Expected = [System.Windows.Automation.AutomationElement]::IsDialogProperty }
            @{ Name = 'ISDoCkpaTTErnAVailABLe'; Expected = [System.Windows.Automation.AutomationElement]::IsDockPatternAvailableProperty }
            @{ Name = 'iSexPaNdCOLlapSEPATteRNAvAIlAble'; Expected = [System.Windows.Automation.AutomationElement]::IsExpandCollapsePatternAvailableProperty }
            @{ Name = 'IsgRIDITeMpAttErNavailABLE'; Expected = [System.Windows.Automation.AutomationElement]::IsGridItemPatternAvailableProperty }
            @{ Name = 'iSgRIDpaTTErNAVaiLaBle'; Expected = [System.Windows.Automation.AutomationElement]::IsGridPatternAvailableProperty }
            @{ Name = 'isINvOkEPatTErNavaiLabLE'; Expected = [System.Windows.Automation.AutomationElement]::IsInvokePatternAvailableProperty }
            @{ Name = 'ismuLtiPLEViEWPATtErnAvAIlAbLE'; Expected = [System.Windows.Automation.AutomationElement]::IsMultipleViewPatternAvailableProperty }
            @{ Name = 'ISrANgEvaluEpattERNavAIlABLE'; Expected = [System.Windows.Automation.AutomationElement]::IsRangeValuePatternAvailableProperty }
            @{ Name = 'isSELEcTionitEMPATtErNAVAiLAbLe'; Expected = [System.Windows.Automation.AutomationElement]::IsSelectionItemPatternAvailableProperty }
            @{ Name = 'IssELectIOnpaTTerNavaIlABLE'; Expected = [System.Windows.Automation.AutomationElement]::IsSelectionPatternAvailableProperty }
            @{ Name = 'iSscRollpAtTERNaVAiLaBle'; Expected = [System.Windows.Automation.AutomationElement]::IsScrollPatternAvailableProperty }
            @{ Name = 'iSsYNcHroNIzeDINpUtpatTErNAVAilAblE'; Expected = [System.Windows.Automation.AutomationElement]::IsSynchronizedInputPatternAvailableProperty }
            @{ Name = 'IsScrolLiTeMPaTTERNAvaIlABlE'; Expected = [System.Windows.Automation.AutomationElement]::IsScrollItemPatternAvailableProperty }
            @{ Name = 'isVIrtUaLIZeDITEMPATTeRNAVAilaBlE'; Expected = [System.Windows.Automation.AutomationElement]::IsVirtualizedItemPatternAvailableProperty }
            @{ Name = 'ISITeMCONtAINeRPatteRNAvailabLe'; Expected = [System.Windows.Automation.AutomationElement]::IsItemContainerPatternAvailableProperty }
            @{ Name = 'istabLePatTernAvaiLAbLe'; Expected = [System.Windows.Automation.AutomationElement]::IsTablePatternAvailableProperty }
            @{ Name = 'IStabLEitemPaTTErnavAILabLe'; Expected = [System.Windows.Automation.AutomationElement]::IsTableItemPatternAvailableProperty }
            @{ Name = 'IsTExTpATternaVaIlable'; Expected = [System.Windows.Automation.AutomationElement]::IsTextPatternAvailableProperty }
            @{ Name = 'istoGGlePaTtErnAvAilabLE'; Expected = [System.Windows.Automation.AutomationElement]::IsTogglePatternAvailableProperty }
            @{ Name = 'iSTRANsForMPaTtERnaVaIlable'; Expected = [System.Windows.Automation.AutomationElement]::IsTransformPatternAvailableProperty }
            @{ Name = 'IsvAlUePATteRnavaILAbLe'; Expected = [System.Windows.Automation.AutomationElement]::IsValuePatternAvailableProperty }
            @{ Name = 'IsWIndOWPAtteRNavAIlabLE'; Expected = [System.Windows.Automation.AutomationElement]::IsWindowPatternAvailableProperty }
        ) {
            $converter.CanConvertFrom($Name, ([System.Windows.Automation.AutomationProperty])) | Should -Be $true
            { $converter.ConvertFrom($Name, ([System.Windows.Automation.AutomationProperty]), $null, $false) } | Should -Throw -ErrorId 'ArgumentException'
            $converter.ConvertFrom($Name, ([System.Windows.Automation.AutomationProperty]), $null, $true) | Should -Be $Expected

            # with `AutomationElement' prefix
            $prefixedName = "auToMAtIonelement.${Name}"
            $converter.CanConvertFrom($prefixedName, ([System.Windows.Automation.AutomationProperty])) | Should -Be $true
            { $converter.ConvertFrom($prefixedName, ([System.Windows.Automation.AutomationProperty]), $null, $false) } | Should -Throw -ErrorId 'ArgumentException'
            $converter.ConvertFrom($prefixedName, ([System.Windows.Automation.AutomationProperty]), $null, $true) | Should -Be $Expected
        }

        It 'Converts string to AutomationProperty defined in Pattern class' -ForEach @(
            @{ Name = 'SelectionItem.IsSelected'; Expected = [System.Windows.Automation.SelectionItemPattern]::IsSelectedProperty }
            @{ Name = 'SelectionItem.SelectionContainer'; Expected = [System.Windows.Automation.SelectionItemPattern]::SelectionContainerProperty }
            @{ Name = 'ExpandCollapse.ExpandCollapseState'; Expected = [System.Windows.Automation.ExpandCollapsePattern]::ExpandCollapseStateProperty }
        ) {
            $converter.CanConvertFrom($Name, ([System.Windows.Automation.AutomationProperty])) | Should -Be $true
            $converter.ConvertFrom($Name, ([System.Windows.Automation.AutomationProperty]), $null, $false) | Should -Be $Expected
            $converter.ConvertFrom($Name, ([System.Windows.Automation.AutomationProperty]), $null, $true) | Should -Be $Expected
        }

        It 'Converts string to AutomationProperty defined in Pattern class (ignoreCase=$true)' -ForEach @(
            @{ Name = 'SELeCtIoniTEM.iSseLectEd'; Expected = [System.Windows.Automation.SelectionItemPattern]::IsSelectedProperty }
            @{ Name = 'seLeCTiOniTem.SELeCTiOnCOnTAIneR'; Expected = [System.Windows.Automation.SelectionItemPattern]::SelectionContainerProperty }
            @{ Name = 'exPandCOllApSE.eXpAndcolLApSEStaTE'; Expected = [System.Windows.Automation.ExpandCollapsePattern]::ExpandCollapseStateProperty }
        ) {
            $converter.CanConvertFrom($Name, ([System.Windows.Automation.AutomationProperty])) | Should -Be $true
            { $converter.ConvertFrom($prefixedName, ([System.Windows.Automation.AutomationProperty]), $null, $false) } | Should -Throw -ErrorId 'ArgumentException'
            $converter.ConvertFrom($Name, ([System.Windows.Automation.AutomationProperty]), $null, $true) | Should -Be $Expected
        }

        It 'Cannot convert unkonwn property type name' -ForEach @(
            @{ Name = 'MyProp' }
            @{ Name = '' }
        ) {
            $converter.CanConvertFrom($Name, ([System.Windows.Automation.AutomationProperty])) | Should -Be $false
            { $converter.ConvertFrom($Name, ([System.Windows.Automation.AutomationProperty]), $null, $true) } | Should -Throw -ErrorId 'ArgumentException'
            { $converter.ConvertFrom($Name, ([System.Windows.Automation.AutomationProperty]), $null, $false) } | Should -Throw -ErrorId 'ArgumentException'
        }
    
        It 'Cannot convert from non-String source value' -ForEach @(
            @{ Name = 1 }
            @{ Name = [PSCustomObject]@{ Name = 'RuntimeId'} }
            @{ Name = $null }
        ) {
            $converter.CanConvertFrom($Name, ([System.Windows.Automation.AutomationProperty])) | Should -Be $false
            { $converter.ConvertFrom($Name, ([System.Windows.Automation.AutomationProperty]), $null, $true) } | Should -Throw -ErrorId 'ArgumentException'
            { $converter.ConvertFrom($Name, ([System.Windows.Automation.AutomationProperty]), $null, $false) } | Should -Throw -ErrorId 'ArgumentException'
        }
    
    
        It 'Cannot convert from string to non-AutomationProperty' -ForEach @(
            @{ Name = 'Name'; DestinationType = ([System.String]) }
            @{ Name = 'ProcessId'; DestinationType = ([System.Windows.Automation.AutomationElement]) }
        ) {
            $converter.CanConvertFrom($Name, ($DestinationType)) | Should -Be $false
            { $converter.ConvertFrom($Name, ($DestinationType), $null, $true) } | Should -Throw -ErrorId 'ArgumentException'
            { $converter.ConvertFrom($Name, ($DestinationType), $null, $false) } | Should -Throw -ErrorId 'ArgumentException'
        }
    }

    Context 'ConvertTo' {
        It 'Not supports ConvertTo' -ForEach @(
            { Src = [AutomationElement]::RuntimeIdProperty; DestinationType = ([string]) }
        ) {
            $converter.CanConvertTo($Src, $DestinationType) | Should -Be $false
            { $converter.ConvertTo($Src, $DestinationType, $null, $true) } | Should -Throw -ErrorId 'NotSupportedException'
        }
    }
}