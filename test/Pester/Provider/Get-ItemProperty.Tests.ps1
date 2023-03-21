Describe 'Get-ItemProperty of PSUI' {
    BeforeAll {
        $ErrorActionPreference = 'Stop'
        . (Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath 'Util.ps1')
        Import-PSUIModule
        $testAppProc = Start-TestApp
        $testAppWindow = Get-Item -LiteralPath 'UI:\' -UIProcessId $testAppProc.Id
        Set-Location 'UI:\'
    }

    AfterAll {
        $testAppProc | Stop-Process
        Set-Location -LiteralPath 'Temp:\'
        Get-Module -Name 'PSUI' | Remove-Module
    }

    It 'Gets element property of AutomationElement' {
        $expected = $testAppProc.UIWindow.GetCurrentPropertyValue([System.Windows.Automation.AutomationElement]::BoundingRectangleProperty);
        $actual = $testAppWindow | Get-ItemProperty -Name 'BoundingRectangle'
        $actual | Should -Not -Be $null
        $actual | Should -Be $expected

        $actual = $testAppWindow | Get-ItemProperty -Name 'boundingrectangle'
        $actual | Should -Not -Be $null
        $actual | Should -Be $expected

        $actual = $testAppWindow | Get-ItemProperty -Name 'AutomationElement.BoundingRectangle'
        $actual | Should -Not -Be $null
        $actual | Should -Be $expected

        $actual = $testAppWindow | Get-ItemProperty -Name 'automationelement.boundingrectangle'
        $actual | Should -Not -Be $null
        $actual | Should -Be $expected
    }

    It 'Gets element property of Pattern' {
        $expected = $testAppProc.UIScrollBar.GetCurrentPropertyValue([System.Windows.Automation.ScrollPattern]::VerticalViewSizeProperty);
        $actual = $testAppWindow
            | Get-ChildItem
            | Where-Object AutomationId -EQ 'scrollBarElement'
            | Get-ItemProperty -Name 'Scroll.VerticalViewSize'
        $actual | Should -Not -Be $null
        $actual | Should -Be $expected

        $actual = $testAppWindow
            | Get-ChildItem
            | Where-Object AutomationId -EQ 'scrollBarElement'
            | Get-ItemProperty -Name 'scroll.verticalviewsize'
        $actual | Should -Not -Be $null
        $actual | Should -Be $expected

    }
}