Describe 'Get-UIPattern' {
    BeforeAll {
        $ErrorActionPreference = 'Stop'
        . (Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath 'Util.ps1')
        Import-PSUIModule
        $testAppProc = Start-TestApp
        $testAppWindow = Get-Item -LiteralPath 'UI:\' -UIProcessId $testAppProc.Id
    }

    AfterAll {
        $testAppProc | Stop-Process
        Set-Location -LiteralPath 'Temp:\'
        Get-Module -Name 'PSUI' | Remove-Module
    }

    It 'Gets all supported patterns with -SupportedPattern parameter' {
        Set-Location -LiteralPath 'UI:'
        $supportedPatterns = $testAppWindow | Get-ChildItem -UIControlType Edit | Get-UIPattern -SupportedPattern
        $supportedPatterns | Should -HaveCount 4
        $supportedPatterns | Where-Object ProgrammaticName -eq 'ValuePatternIdentifiers.Pattern' |  Should -HaveCount 1
        $supportedPatterns | Where-Object ProgrammaticName -eq 'ScrollPatternIdentifiers.Pattern' |  Should -HaveCount 1
        $supportedPatterns | Where-Object ProgrammaticName -eq 'TextPatternIdentifiers.Pattern' |  Should -HaveCount 1
        $supportedPatterns | Where-Object ProgrammaticName -eq 'SynchronizedInputPatternIdentifiers.Pattern' |  Should -HaveCount 1
    }

    It 'Gets specified pattern with -Pattern parameter' {
        Set-Location -LiteralPath 'UI:'

        $pattern = $testAppWindow | Get-ChildItem -UIControlType Edit | Get-UIPattern -Pattern Value
        $pattern | Should -HaveCount 1
        $pattern | Should -BeOfType [System.Windows.Automation.ValuePattern]

        $pattern = $testAppWindow | Get-ChildItem -UIControlType Edit | Get-UIPattern -Pattern Scroll
        $pattern | Should -HaveCount 1
        $pattern | Should -BeOfType [System.Windows.Automation.ScrollPattern]

        $pattern = $testAppWindow | Get-ChildItem -UIControlType Edit | Get-UIPattern -Pattern Text
        $pattern | Should -HaveCount 1
        $pattern | Should -BeOfType [System.Windows.Automation.TextPattern]

        $pattern = $testAppWindow | Get-ChildItem -UIControlType Edit | Get-UIPattern -Pattern SynchronizedInput
        $pattern | Should -HaveCount 1
        $pattern | Should -BeOfType [System.Windows.Automation.SynchronizedInputPattern]
    }

    It 'Throws error with unknown -Pattern parameter value' {
        Set-Location -LiteralPath 'UI:'
        { $testAppWindow | Get-ChildItem -UIControlType Edit | Get-UIPattern -Pattern MyPattern } | Should -Throw -ErrorId 'CannotConvertArgumentNoMessage,PSUI.GetUIPatternCommand'
    }
}