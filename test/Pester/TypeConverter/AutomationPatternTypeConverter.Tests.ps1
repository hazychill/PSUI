Describe 'AutomationPatternTypeConverter' {
    BeforeDiscovery {
        Add-Type -AssemblyName 'UIAutomationClient'
    }

    BeforeAll {
        $ErrorActionPreference = 'Stop'
        . (Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath 'Util.ps1')
        Import-PSUIModule
        $converter = [PSUI.AutomationPatternTypeConverter]::Instance
    }

    Context 'ConvertFrom' {
        It 'Converts string name to AutomationPattern' -ForEach @(
            @{ Name = 'Dock'; Expected = [System.Windows.Automation.DockPattern]::Pattern }
            @{ Name = 'ExpandCollapse'; Expected = [System.Windows.Automation.ExpandCollapsePattern]::Pattern }
            @{ Name = 'Invoke'; Expected = [System.Windows.Automation.InvokePattern]::Pattern }
            @{ Name = 'SelectionItem'; Expected = [System.Windows.Automation.SelectionItemPattern]::Pattern }
            @{ Name = 'Value'; Expected = [System.Windows.Automation.ValuePattern]::Pattern }
        ) {
            $converter.CanConvertFrom($Name, ([System.Windows.Automation.AutomationPattern])) | Should -Be $true
            $converter.ConvertFrom($Name, ([System.Windows.Automation.AutomationPattern]), $null, $false) | Should -Be $Expected
            $converter.ConvertFrom($Name, ([System.Windows.Automation.AutomationPattern]), $null, $true) | Should -Be $Expected
        }

        It 'Converts string name to AutomationPattern (ignoreCase=$true)' -ForEach @(
            @{ Name = 'dock'; Expected = [System.Windows.Automation.DockPattern]::Pattern }
            @{ Name = 'expandcollapse'; Expected = [System.Windows.Automation.ExpandCollapsePattern]::Pattern }
            @{ Name = 'invoke'; Expected = [System.Windows.Automation.InvokePattern]::Pattern }
            @{ Name = 'selectionitem'; Expected = [System.Windows.Automation.SelectionItemPattern]::Pattern }
            @{ Name = 'value'; Expected = [System.Windows.Automation.ValuePattern]::Pattern }
        ) {
            $converter.CanConvertFrom($Name, ([System.Windows.Automation.AutomationPattern])) | Should -Be $true
            { $converter.ConvertFrom($Name, ([System.Windows.Automation.AutomationPattern]), $null, $false) } | Should -Throw -ErrorId 'ArgumentException'
            $converter.ConvertFrom($Name, ([System.Windows.Automation.AutomationPattern]), $null, $true) | Should -Be $Expected
        }

        It 'Cannot convert unkonwn pattern name' -ForEach @(
            @{ Name = 'MyPattern' }
            @{ Name = '' }
        ) {
            $converter.CanConvertFrom($Name, ([System.Windows.Automation.AutomationPattern])) | Should -Be $false
            { $converter.ConvertFrom($Name, ([System.Windows.Automation.AutomationPattern]), $null, $false) } | Should -Throw -ErrorId 'ArgumentException'
            { $converter.ConvertFrom($Name, ([System.Windows.Automation.AutomationPattern]), $null, $true) } | Should -Throw -ErrorId 'ArgumentException'
        }

        It 'Cannot convert from non-String source value' -ForEach @(
            @{ Name = 1 }
            @{ Name = [PSCustomObject]@{ Name = 'Invoke' } }
            @{ Name = $null }
        ) {
            $converter.CanConvertFrom($Name, ([System.Windows.Automation.AutomationPattern])) | Should -Be $false
            { $converter.ConvertFrom($Name, ([System.Windows.Automation.AutomationPattern]), $null, $false) } | Should -Throw -ErrorId 'ArgumentException'
            { $converter.ConvertFrom($Name, ([System.Windows.Automation.AutomationPattern]), $null, $true) } | Should -Throw -ErrorId 'ArgumentException'
        }

        It 'Cannot convert from string to non-AutomationPattern' -ForEach @(
            @{ Name = 'Invoke'; DestinationType = ([System.String]) }
            @{ Name = 'Value'; DestinationType = ([System.Windows.Automation.AutomationElement]) }
        ) {
            $converter.CanConvertFrom($Name, $DestinationType) | Should -Be $false
            { $converter.ConvertFrom($Name, $DestinationType, $null, $false) } | Should -Throw -ErrorId 'ArgumentException'
            { $converter.ConvertFrom($Name, $DestinationType, $null, $true) } | Should -Throw -ErrorId 'ArgumentException'
        }
    }

    Context 'ConvertTo' {
        It 'Not supports ConvertTo' -ForEach @(
            { Src = [System.Windows.Automation.InvokePattern]::Pattern; DestinationType = ([string]) }
        ) {
            $converter.CanConvertTo($Src, $DestinationType) | Should -Be $false
            { $converter.ConvertTo($Src, $DestinationType, $null, $false) } | Should -Throw -ErrorId 'NotSupportedException'
            { $converter.ConvertTo($Src, $DestinationType, $null, $true) } | Should -Throw -ErrorId 'NotSupportedException'
        }
    }
}