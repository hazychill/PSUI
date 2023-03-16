Describe 'Remove-PSDrive of PSUI' {
    BeforeAll {
        $ErrorActionPreference = 'Stop'
        . (Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath 'Util.ps1')
        Import-PSUIModule
    }

    AfterAll {
        Set-Location -LiteralPath 'Temp:\'
        Get-Module -Name 'PSUI' | Remove-Module
    }

    It 'Remove drive for PSUI' {
        $rootElement = Get-ChildItem -LiteralPath 'UI:\'
        | Where-Object {
            $item = $_
            -not [string]::IsNullOrEmpty($item.GetCurrentPropertyValue([System.Windows.Automation.AutomationElement]::NameProperty))
        }
        | Select-Object -First 1
        $rootElement | Should -Not -Be $null
        $driveName = 'UITestDrive'
        $drive = New-PSDrive -Name $driveName -PSProvider 'UI' -Root $rootElement.PSPath
        $drive | Should -Not -Be $null
        (Get-PSDrive -Name $driveName).Provider.ImplementingType | Should -Be ([PSUI.Provider.UIProvider])

        Get-PSDrive | Where-Object Name -eq $driveName | Should -HaveCount 1
        Remove-PSDrive -Name $driveName
        Get-PSDrive | Where-Object Name -eq $driveName | Should -HaveCount 0
    }
}