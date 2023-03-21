Describe 'Test-Path of PSUI' {
    BeforeAll {
        $ErrorActionPreference = 'Stop'
        . (Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath 'Util.ps1')
        Import-PSUIModule
    }

    AfterAll {
        Set-Location -LiteralPath 'Temp:\'
        Get-Module -Name 'PSUI' | Remove-Module
    }

    BeforeEach {
        [System.Diagnostics.Process]$testAppProcess = $null
    }

    AfterEach {
        if (($null -ne $testAppProcess) -and (-not $testAppProcess.HasExited)) {
            $testAppProcess | Stop-Process
        }
    }

    It 'Returns true for valid and exist path' {
        $testAppProcess = Start-TestApp

        $windowRuntimeId = $testAppProcess.UIWindow.ItemId
        $path = "UI:\${windowRuntimeId}"
        Test-Path -LiteralPath $path | Should -Be $true
        $path = "UI::ROOT\${windowRuntimeId}"
        Test-Path -LiteralPath $path | Should -Be $true

        $buttonRuntimeId = $testAppProcess.UIButton.ItemId
        $path = "UI:\${windowRuntimeId}\${buttonRuntimeId}"
        Test-Path -LiteralPath $path | Should -Be $true
        $path = "UI::ROOT\${windowRuntimeId}\${buttonRuntimeId}"
        Test-Path -LiteralPath $path | Should -Be $true
    }

    It 'Returns false for invalid path' -ForEach @(
        @{ Path = 'UI:\1,2,3\a' }
        @{ Path = 'UI:\99999999999999999999999999999999999999\' }
        @{ Path = 'UI:\1.1\' }
        @{ Path = 'UI::ROOT\1,2,3\a' }
        @{ Path = 'UI::ROOT\99999999999999999999999999999999999999\' }
        @{ Path = 'UI::ROOT\1.1\' }
    ) {
        Test-Path -LiteralPath $Path | Should -Be $false
    }

    It 'Return false for not exist path' -ForEach @(
        @{ Path = 'UI:\1,2,3,4,5,6,7,8,9,0' }
        @{ Path = 'UI:\1\2\3\4\5\6\7\8\9\0' }
        @{ Path = 'UI::ROOT\1,2,3,4,5,6,7,8,9,0' }
        @{ Path = 'UI::ROOT\1\2\3\4\5\6\7\8\9\0' }
    ) {
        Test-Path -LiteralPath $Path | Should -Be $false
    }

    It 'Returns false for disappered path' {
        $testAppProcess = Start-TestApp

        $windowRuntimeId = $testAppProcess.UIWindow.ItemId
        $path = "UI:\${windowRuntimeId}"
        Test-Path -LiteralPath $path | Should -Be $true
        $path = "UI::ROOT\${windowRuntimeId}"
        Test-Path -LiteralPath $path | Should -Be $true

        $testAppProcess | Stop-Process
        $path = "UI:\${windowRuntimeId}"
        Test-Path -LiteralPath $path | Should -Be $false
        $path = "UI::ROOT\${windowRuntimeId}"
        Test-Path -LiteralPath $path | Should -Be $false

    }
}