Describe 'Get-PSDrive of PSUI' {
    BeforeAll {
        $ErrorActionPreference = 'Stop'
        . (Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath 'Util.ps1')
        Import-PSUIModule
    }

    AfterAll {
        Set-Location -LiteralPath 'Temp:\'
        Get-Module -Name 'PSUI' | Remove-Module
    }

    It 'Gets Default UI: drive' {
        $drive = Get-PSDrive -Name 'UI'
        $drive.Provider.ImplementingType | Should -Be ([PSUI.Provider.UIProvider])
    }

    It 'Gets newly created PSUI drive' {
        $rootElement = Get-ChildItem -LiteralPath 'UI:\'
        | Where-Object {
            $item = $_
            -not [string]::IsNullOrEmpty($item.GetCurrentPropertyValue([System.Windows.Automation.AutomationElement]::NameProperty))
        }
        | Select-Object -First 1
        $rootElement | Should -Not -Be $null
        $driveName = 'UITestDrive'
        $drive = New-PSDrive -Name $driveName -PSProvider 'UI' -Root $rootElement.PSPath
        Get-PSDrive -Name $driveName | Should -Be $drive
    }
}