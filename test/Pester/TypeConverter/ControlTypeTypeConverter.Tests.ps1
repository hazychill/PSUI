Describe 'ControlTypeTypeConverter' {
    BeforeDiscovery {
        Add-Type -AssemblyName 'UIAutomationClient'

        # though I cannot understand why
        # without this line, [System.Windows.Automation.ControlType] cannot be found
        [void]([System.Windows.Automation.AutomationElement]::RootElement)
    }

    BeforeAll {
        $ErrorActionPreference = 'Stop'
        . (Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath 'Util.ps1')
        Import-PSUIModule
        $converter = [PSUI.ControlTypeTypeConverter]::Instance
    }

    Context 'ConvertFrom' {
        It 'Converts string name of control type to ControlType' -ForEach @(
            @{ Name = 'Button'; Expected = [System.Windows.Automation.ControlType]::Button }
            @{ Name = 'Calendar'; Expected = [System.Windows.Automation.ControlType]::Calendar }
            @{ Name = 'CheckBox'; Expected = [System.Windows.Automation.ControlType]::CheckBox }
            @{ Name = 'ComboBox'; Expected = [System.Windows.Automation.ControlType]::ComboBox }
            @{ Name = 'Custom'; Expected = [System.Windows.Automation.ControlType]::Custom }
            @{ Name = 'DataGrid'; Expected = [System.Windows.Automation.ControlType]::DataGrid }
            @{ Name = 'DataItem'; Expected = [System.Windows.Automation.ControlType]::DataItem }
            @{ Name = 'Document'; Expected = [System.Windows.Automation.ControlType]::Document }
            @{ Name = 'Edit'; Expected = [System.Windows.Automation.ControlType]::Edit }
            @{ Name = 'Group'; Expected = [System.Windows.Automation.ControlType]::Group }
            @{ Name = 'Header'; Expected = [System.Windows.Automation.ControlType]::Header }
            @{ Name = 'HeaderItem'; Expected = [System.Windows.Automation.ControlType]::HeaderItem }
            @{ Name = 'Hyperlink'; Expected = [System.Windows.Automation.ControlType]::Hyperlink }
            @{ Name = 'Image'; Expected = [System.Windows.Automation.ControlType]::Image }
            @{ Name = 'List'; Expected = [System.Windows.Automation.ControlType]::List }
            @{ Name = 'ListItem'; Expected = [System.Windows.Automation.ControlType]::ListItem }
            @{ Name = 'Menu'; Expected = [System.Windows.Automation.ControlType]::Menu }
            @{ Name = 'MenuBar'; Expected = [System.Windows.Automation.ControlType]::MenuBar }
            @{ Name = 'MenuItem'; Expected = [System.Windows.Automation.ControlType]::MenuItem }
            @{ Name = 'Pane'; Expected = [System.Windows.Automation.ControlType]::Pane }
            @{ Name = 'ProgressBar'; Expected = [System.Windows.Automation.ControlType]::ProgressBar }
            @{ Name = 'RadioButton'; Expected = [System.Windows.Automation.ControlType]::RadioButton }
            @{ Name = 'ScrollBar'; Expected = [System.Windows.Automation.ControlType]::ScrollBar }
            @{ Name = 'Separator'; Expected = [System.Windows.Automation.ControlType]::Separator }
            @{ Name = 'Slider'; Expected = [System.Windows.Automation.ControlType]::Slider }
            @{ Name = 'Spinner'; Expected = [System.Windows.Automation.ControlType]::Spinner }
            @{ Name = 'SplitButton'; Expected = [System.Windows.Automation.ControlType]::SplitButton }
            @{ Name = 'StatusBar'; Expected = [System.Windows.Automation.ControlType]::StatusBar }
            @{ Name = 'Tab'; Expected = [System.Windows.Automation.ControlType]::Tab }
            @{ Name = 'TabItem'; Expected = [System.Windows.Automation.ControlType]::TabItem }
            @{ Name = 'Table'; Expected = [System.Windows.Automation.ControlType]::Table }
            @{ Name = 'Text'; Expected = [System.Windows.Automation.ControlType]::Text }
            @{ Name = 'Thumb'; Expected = [System.Windows.Automation.ControlType]::Thumb }
            @{ Name = 'TitleBar'; Expected = [System.Windows.Automation.ControlType]::TitleBar }
            @{ Name = 'ToolBar'; Expected = [System.Windows.Automation.ControlType]::ToolBar }
            @{ Name = 'ToolTip'; Expected = [System.Windows.Automation.ControlType]::ToolTip }
            @{ Name = 'Tree'; Expected = [System.Windows.Automation.ControlType]::Tree }
            @{ Name = 'TreeItem'; Expected = [System.Windows.Automation.ControlType]::TreeItem }
            @{ Name = 'Window'; Expected = [System.Windows.Automation.ControlType]::Window }
        ) {
            $converter.CanConvertFrom($Name, ([System.Windows.Automation.ControlType])) | Should -Be $true
            $converter.ConvertFrom($Name, ([System.Windows.Automation.ControlType]), $null, $false) | Should -Be $Expected
            $converter.ConvertFrom($Name, ([System.Windows.Automation.ControlType]), $null, $true) | Should -Be $Expected

            # with `ControlType' prefix
            $prefixedName = "ControlType.${Name}"
            $converter.CanConvertFrom($prefixedName, ([System.Windows.Automation.ControlType])) | Should -Be $true
            $converter.ConvertFrom($prefixedName, ([System.Windows.Automation.ControlType]), $null, $false) | Should -Be $Expected
            $converter.ConvertFrom($prefixedName, ([System.Windows.Automation.ControlType]), $null, $true) | Should -Be $Expected
        }
    
        It 'Converts string name of control type to ControlType (ignoreCase=$true)' -ForEach @(
            @{ Name = 'BUtTon'; Expected = [System.Windows.Automation.ControlType]::Button }
            @{ Name = 'caLEndar'; Expected = [System.Windows.Automation.ControlType]::Calendar }
            @{ Name = 'cHECKBox'; Expected = [System.Windows.Automation.ControlType]::CheckBox }
            @{ Name = 'cOMBoBoX'; Expected = [System.Windows.Automation.ControlType]::ComboBox }
            @{ Name = 'cUSToM'; Expected = [System.Windows.Automation.ControlType]::Custom }
            @{ Name = 'daTagRiD'; Expected = [System.Windows.Automation.ControlType]::DataGrid }
            @{ Name = 'DaTaitEM'; Expected = [System.Windows.Automation.ControlType]::DataItem }
            @{ Name = 'DOCUmeNt'; Expected = [System.Windows.Automation.ControlType]::Document }
            @{ Name = 'eDit'; Expected = [System.Windows.Automation.ControlType]::Edit }
            @{ Name = 'group'; Expected = [System.Windows.Automation.ControlType]::Group }
            @{ Name = 'hEadeR'; Expected = [System.Windows.Automation.ControlType]::Header }
            @{ Name = 'HEadERitEm'; Expected = [System.Windows.Automation.ControlType]::HeaderItem }
            @{ Name = 'hypERliNK'; Expected = [System.Windows.Automation.ControlType]::Hyperlink }
            @{ Name = 'iMAGE'; Expected = [System.Windows.Automation.ControlType]::Image }
            @{ Name = 'LIsT'; Expected = [System.Windows.Automation.ControlType]::List }
            @{ Name = 'LIStItEM'; Expected = [System.Windows.Automation.ControlType]::ListItem }
            @{ Name = 'menU'; Expected = [System.Windows.Automation.ControlType]::Menu }
            @{ Name = 'meNUBar'; Expected = [System.Windows.Automation.ControlType]::MenuBar }
            @{ Name = 'mEnUitEM'; Expected = [System.Windows.Automation.ControlType]::MenuItem }
            @{ Name = 'pANE'; Expected = [System.Windows.Automation.ControlType]::Pane }
            @{ Name = 'PRoGrESsBAR'; Expected = [System.Windows.Automation.ControlType]::ProgressBar }
            @{ Name = 'raDioBUttON'; Expected = [System.Windows.Automation.ControlType]::RadioButton }
            @{ Name = 'SCROLlBAR'; Expected = [System.Windows.Automation.ControlType]::ScrollBar }
            @{ Name = 'sePAratoR'; Expected = [System.Windows.Automation.ControlType]::Separator }
            @{ Name = 'slider'; Expected = [System.Windows.Automation.ControlType]::Slider }
            @{ Name = 'SPINner'; Expected = [System.Windows.Automation.ControlType]::Spinner }
            @{ Name = 'SplItBUtToN'; Expected = [System.Windows.Automation.ControlType]::SplitButton }
            @{ Name = 'STatUSBaR'; Expected = [System.Windows.Automation.ControlType]::StatusBar }
            @{ Name = 'tAB'; Expected = [System.Windows.Automation.ControlType]::Tab }
            @{ Name = 'taBItem'; Expected = [System.Windows.Automation.ControlType]::TabItem }
            @{ Name = 'tabLe'; Expected = [System.Windows.Automation.ControlType]::Table }
            @{ Name = 'TexT'; Expected = [System.Windows.Automation.ControlType]::Text }
            @{ Name = 'tHumB'; Expected = [System.Windows.Automation.ControlType]::Thumb }
            @{ Name = 'TitlebaR'; Expected = [System.Windows.Automation.ControlType]::TitleBar }
            @{ Name = 'tOoLBaR'; Expected = [System.Windows.Automation.ControlType]::ToolBar }
            @{ Name = 'tooltiP'; Expected = [System.Windows.Automation.ControlType]::ToolTip }
            @{ Name = 'tREE'; Expected = [System.Windows.Automation.ControlType]::Tree }
            @{ Name = 'tREeItem'; Expected = [System.Windows.Automation.ControlType]::TreeItem }
            @{ Name = 'WiNDOw'; Expected = [System.Windows.Automation.ControlType]::Window }
        ) {
            $converter.CanConvertFrom($Name, ([System.Windows.Automation.ControlType])) | Should -Be $true
            $converter.ConvertFrom($Name, ([System.Windows.Automation.ControlType]), $null, $true) | Should -Be $Expected
            { $converter.ConvertFrom($Name, ([System.Windows.Automation.ControlType]), $null, $false) } | Should -Throw -ErrorId 'ArgumentException'

            # with `ControlType' prefix
            $prefixedName = "coNtROltYPE.${Name}"
            $converter.CanConvertFrom($prefixedName, ([System.Windows.Automation.ControlType])) | Should -Be $true
            $converter.ConvertFrom($prefixedName, ([System.Windows.Automation.ControlType]), $null, $true) | Should -Be $Expected
            { $converter.ConvertFrom($prefixedName, ([System.Windows.Automation.ControlType]), $null, $false) } | Should -Throw -ErrorId 'ArgumentException'
        }

        It 'Cannot convert unkonwn control type name' -ForEach @(
            @{ Name = 'MyButton' }
            @{ Name = '' }
        ) {
            $converter.CanConvertFrom($Name, ([System.Windows.Automation.ControlType])) | Should -Be $false
            { $converter.ConvertFrom($Name, ([System.Windows.Automation.ControlType]), $null, $true) } | Should -Throw -ErrorId 'ArgumentException'
            { $converter.ConvertFrom($Name, ([System.Windows.Automation.ControlType]), $null, $false) } | Should -Throw -ErrorId 'ArgumentException'
        }
    
        It 'Cannot convert from non-String source value' -ForEach @(
            @{ Name = 1 }
            @{ Name = [PSCustomObject]@{ Name = 'Button'} }
            @{ Name = $null }
        ) {
            $converter.CanConvertFrom($Name, ([System.Windows.Automation.ControlType])) | Should -Be $false
            { $converter.ConvertFrom($Name, ([System.Windows.Automation.ControlType]), $null, $true) } | Should -Throw -ErrorId 'ArgumentException'
            { $converter.ConvertFrom($Name, ([System.Windows.Automation.ControlType]), $null, $false) } | Should -Throw -ErrorId 'ArgumentException'
        }
    
    
        It 'Cannot convert from string to non-ControlType' -ForEach @(
            @{ Name = 'Button'; DestinationType = ([System.String]) }
            @{ Name = 'Button'; DestinationType = ([System.Windows.Automation.AutomationElement]) }
        ) {
            $converter.CanConvertFrom($Name, ($DestinationType)) | Should -Be $false
            { $converter.ConvertFrom($Name, ($DestinationType), $null, $true) } | Should -Throw -ErrorId 'ArgumentException'
            { $converter.ConvertFrom($Name, ($DestinationType), $null, $false) } | Should -Throw -ErrorId 'ArgumentException'
        }
    }

    Context 'ConvertTo' {
        It 'Converts ControlType to its name' -ForEach @(
            @{ Src = [System.Windows.Automation.ControlType]::Button; Expected = 'Button' }
            @{ Src = [System.Windows.Automation.ControlType]::Calendar; Expected = 'Calendar' }
            @{ Src = [System.Windows.Automation.ControlType]::CheckBox; Expected = 'CheckBox' }
            @{ Src = [System.Windows.Automation.ControlType]::ComboBox; Expected = 'ComboBox' }
            @{ Src = [System.Windows.Automation.ControlType]::Custom; Expected = 'Custom' }
            @{ Src = [System.Windows.Automation.ControlType]::DataGrid; Expected = 'DataGrid' }
            @{ Src = [System.Windows.Automation.ControlType]::DataItem; Expected = 'DataItem' }
            @{ Src = [System.Windows.Automation.ControlType]::Document; Expected = 'Document' }
            @{ Src = [System.Windows.Automation.ControlType]::Edit; Expected = 'Edit' }
            @{ Src = [System.Windows.Automation.ControlType]::Group; Expected = 'Group' }
            @{ Src = [System.Windows.Automation.ControlType]::Header; Expected = 'Header' }
            @{ Src = [System.Windows.Automation.ControlType]::HeaderItem; Expected = 'HeaderItem' }
            @{ Src = [System.Windows.Automation.ControlType]::Hyperlink; Expected = 'Hyperlink' }
            @{ Src = [System.Windows.Automation.ControlType]::Image; Expected = 'Image' }
            @{ Src = [System.Windows.Automation.ControlType]::List; Expected = 'List' }
            @{ Src = [System.Windows.Automation.ControlType]::ListItem; Expected = 'ListItem' }
            @{ Src = [System.Windows.Automation.ControlType]::Menu; Expected = 'Menu' }
            @{ Src = [System.Windows.Automation.ControlType]::MenuBar; Expected = 'MenuBar' }
            @{ Src = [System.Windows.Automation.ControlType]::MenuItem; Expected = 'MenuItem' }
            @{ Src = [System.Windows.Automation.ControlType]::Pane; Expected = 'Pane' }
            @{ Src = [System.Windows.Automation.ControlType]::ProgressBar; Expected = 'ProgressBar' }
            @{ Src = [System.Windows.Automation.ControlType]::RadioButton; Expected = 'RadioButton' }
            @{ Src = [System.Windows.Automation.ControlType]::ScrollBar; Expected = 'ScrollBar' }
            @{ Src = [System.Windows.Automation.ControlType]::Separator; Expected = 'Separator' }
            @{ Src = [System.Windows.Automation.ControlType]::Slider; Expected = 'Slider' }
            @{ Src = [System.Windows.Automation.ControlType]::Spinner; Expected = 'Spinner' }
            @{ Src = [System.Windows.Automation.ControlType]::SplitButton; Expected = 'SplitButton' }
            @{ Src = [System.Windows.Automation.ControlType]::StatusBar; Expected = 'StatusBar' }
            @{ Src = [System.Windows.Automation.ControlType]::Tab; Expected = 'Tab' }
            @{ Src = [System.Windows.Automation.ControlType]::TabItem; Expected = 'TabItem' }
            @{ Src = [System.Windows.Automation.ControlType]::Table; Expected = 'Table' }
            @{ Src = [System.Windows.Automation.ControlType]::Text; Expected = 'Text' }
            @{ Src = [System.Windows.Automation.ControlType]::Thumb; Expected = 'Thumb' }
            @{ Src = [System.Windows.Automation.ControlType]::TitleBar; Expected = 'TitleBar' }
            @{ Src = [System.Windows.Automation.ControlType]::ToolBar; Expected = 'ToolBar' }
            @{ Src = [System.Windows.Automation.ControlType]::ToolTip; Expected = 'ToolTip' }
            @{ Src = [System.Windows.Automation.ControlType]::Tree; Expected = 'Tree' }
            @{ Src = [System.Windows.Automation.ControlType]::TreeItem; Expected = 'TreeItem' }
            @{ Src = [System.Windows.Automation.ControlType]::Window; Expected = 'Window' }
        ) {
            $converter.CanConvertTo($Src, ([string])) | Should -Be $true
            $converter.ConvertTo($Src, ([string]), $null, $false) | Should -Be $Expected
            $converter.ConvertTo($Src, ([string]), $null, $true) | Should -Be $Expected
        }

        It 'Cannot convert from non-ControlType' -ForEach @(
            @{ Src = 'Button' }
            @{ Src = [pscustomobject]@{} }
        ) {
            $converter.CanConvertTo($Src, ([string])) | Should -Be $false
            { $converter.ConvertTo($Src, ([string]), $null, $false) } | Should -Throw -ErrorId 'ArgumentException'
            { $converter.ConvertTo($Src, ([string]), $null, $true) } | Should -Throw -ErrorId 'ArgumentException'
        }

        It 'Cannot convert to non-string' -ForEach @(
            @{ Src = [System.Windows.Automation.ControlType]::Button ; DestinationType = ([int])}
            @{ Src = [System.Windows.Automation.ControlType]::Button ; DestinationType = ([System.Windows.Automation.AutomationElement])}
        ) {
            $converter.CanConvertTo($Src, $DestinationType) | Should -Be $false
            { $converter.ConvertTo($Src, $DestinationType, $null, $false) } | Should -Throw -ErrorId 'ArgumentException'
            { $converter.ConvertTo($Src, $DestinationType, $null, $true) } | Should -Throw -ErrorId 'ArgumentException'
        }
    }
}
