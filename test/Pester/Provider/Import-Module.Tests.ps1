Describe 'Import-Module of PSUI' {
    BeforeAll {
        $ErrorActionPreference = 'Stop'
        . (Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath 'Util.ps1')
        $modulePath = Get-PSUIModuleLocation
    }

    AfterEach {
        Set-Location -LiteralPath 'Temp:\'
        Get-Module -Name 'PSUI' | Remove-Module
    }

    It 'Creates default UI: drive' {
        Get-Module -Name 'PSUI' | Should -HaveCount 0
        Get-PSDrive | Where-Object Name -eq UI | Should -HaveCount 0

        Import-Module -Name $modulePath

        Get-Module -Name 'PSUI' | Should -HaveCount 1
        $drive = Get-PSDrive -Name 'UI'
        $drive.Provider.ImplementingType | Should -Be ([PSUI.Provider.UIProvider])
    }
}
