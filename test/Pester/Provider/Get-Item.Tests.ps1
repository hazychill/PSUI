Describe 'Get-Item of PSUI' {
    BeforeAll {
        $ErrorActionPreference = 'Stop'
        . (Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath 'Util.ps1')
        Import-PSUIModule
    }

    AfterAll {
        Set-Location -LiteralPath 'Temp:\'
        Get-Module -Name 'PSUI' | Remove-Module
    }

    It 'Gets root item with provider path' {
        $rootItem = Get-Item -LiteralPath 'UI::ROOT'
        $rootAutomationElement = [System.Windows.Automation.AutomationElement]::RootElement
        $rootItem | Should -Be $rootAutomationElement
    }

    It 'Gets root item with drive path' {
        $rootAutomationElement = [System.Windows.Automation.AutomationElement]::RootElement

        $rootItem = Get-Item -LiteralPath 'UI:\'
        $rootItem | Should -Be $rootAutomationElement

        $rootItem = Get-Item -LiteralPath 'UI:'
        $rootItem | Should -Be $rootAutomationElement

        $rootItem = Get-Item -LiteralPath 'UI:/'
        $rootItem | Should -Be $rootAutomationElement
    }

    Context 'with TestApp' {
        BeforeAll {
            $testAppProc = Start-TestApp

            $testAppWin = $testAppProc.UIWindow
            $testAppWinRuntimeId = (Get-RuntimeIdProperty -Element $testAppWin) -join ','

            $button = $testAppProc.UIButton
            $buttonRuntimeId = (Get-RuntimeIdProperty -Element $button) -join ','
        }

        AfterAll {
            $testAppProc | Stop-Process
        }

        It 'Gets UI item with full path' {
            $path = "UI::ROOT\${testAppWinRuntimeId}\${buttonRuntimeId}"
            Get-Item -LiteralPath $path | Should -Be $button
 
            $path = "UI::ROOT\${testAppWinRuntimeId}\${buttonRuntimeId}\"
            Get-Item -LiteralPath $path | Should -Be $button

            $path = "UI::ROOT\${testAppWinRuntimeId}\${buttonRuntimeId}"
            Get-Item -LiteralPath $path | Should -Be $button

            $path = "UI:\${testAppWinRuntimeId}\${buttonRuntimeId}"
            Get-Item -LiteralPath $path | Should -Be $button

            $path = "UI:\${testAppWinRuntimeId}\${buttonRuntimeId}\"
            Get-Item -LiteralPath $path | Should -Be $button

            $path = "UI::ROOT/${testAppWinRuntimeId}/${buttonRuntimeId}"
            Get-Item -LiteralPath $path | Should -Be $button
 
            $path = "UI::ROOT/${testAppWinRuntimeId}/${buttonRuntimeId}/"
            Get-Item -LiteralPath $path | Should -Be $button

            $path = "UI::ROOT/${testAppWinRuntimeId}/${buttonRuntimeId}"
            Get-Item -LiteralPath $path | Should -Be $button

            $path = "UI:/${testAppWinRuntimeId}/${buttonRuntimeId}"
            Get-Item -LiteralPath $path | Should -Be $button

            $path = "UI:/${testAppWinRuntimeId}/${buttonRuntimeId}/"
            Get-Item -LiteralPath $path | Should -Be $button

            $path = "UI::ROOT\${testAppWinRuntimeId}/${buttonRuntimeId}"
            Get-Item -LiteralPath $path | Should -Be $button

            $path = "UI::ROOT/${testAppWinRuntimeId}\${buttonRuntimeId}"
            Get-Item -LiteralPath $path | Should -Be $button

            $path = "UI:\${testAppWinRuntimeId}\${buttonRuntimeId}/"
            Get-Item -LiteralPath $path | Should -Be $button
        }

        It 'Gets UI item with relative path' {
            Set-Location -LiteralPath 'UI::ROOT'
            Get-Item -LiteralPath "${testAppWinRuntimeId}\${buttonRuntimeId}" | Should -Be $button

            Set-Location -LiteralPath 'UI::ROOT'
            Get-Item -LiteralPath "${testAppWinRuntimeId}\${buttonRuntimeId}\" | Should -Be $button

            Set-Location -LiteralPath 'UI::ROOT'
            Get-Item -LiteralPath ".\${testAppWinRuntimeId}\${buttonRuntimeId}" | Should -Be $button

            Set-Location -LiteralPath "UI::ROOT\${testAppWinRuntimeId}"
            Get-Item -LiteralPath "${buttonRuntimeId}" | Should -Be $button

            Set-Location -LiteralPath "UI::ROOT\${testAppWinRuntimeId}"
            Get-Item -LiteralPath ".\${buttonRuntimeId}" | Should -Be $button

            Set-Location -LiteralPath 'UI:\'
            Get-Item -LiteralPath "${testAppWinRuntimeId}\${buttonRuntimeId}" | Should -Be $button

            Set-Location -LiteralPath "UI:\${testAppWinRuntimeId}"
            Get-Item -LiteralPath "${buttonRuntimeId}" | Should -Be $button
        }

        It 'Gets top level UI item with ProcessId' {
            Get-Item -LiteralPath 'UI:\' -UIProcessId $testAppProc.ID | Should -Be $testAppWin
        }
    }
}