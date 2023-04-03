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
        $actual.BoundingRectangle | Should -Be $expected

        $actual = $testAppWindow | Get-ItemProperty -Name 'boundingrectangle'
        $actual | Should -Not -Be $null
        $actual.BoundingRectangle | Should -Be $expected

        $actual = $testAppWindow | Get-ItemProperty -Name 'AutomationElement.BoundingRectangle'
        $actual.('AutomationElement.BoundingRectangle') | Should -Not -Be $null
        $actual.('AutomationElement.BoundingRectangle') | Should -Be $expected

        $actual = $testAppWindow | Get-ItemProperty -Name 'automationelement.boundingrectangle'
        $actual.('AutomationElement.BoundingRectangle') | Should -Not -Be $null
        $actual.('AutomationElement.BoundingRectangle') | Should -Be $expected
    }

    It 'Gets element property of Pattern' {
        $expected = $testAppProc.UIScrollBar.GetCurrentPropertyValue([System.Windows.Automation.ScrollPattern]::VerticalViewSizeProperty);
        $actual = $testAppWindow
            | Get-ChildItem
            | Where-Object AutomationId -EQ 'scrollBarElement'
            | Get-ItemProperty -Name 'Scroll.VerticalViewSize'
        $actual.('Scroll.VerticalViewSize') | Should -Not -Be $null
        $actual.('Scroll.VerticalViewSize') | Should -Be $expected

        $actual = $testAppWindow
            | Get-ChildItem
            | Where-Object AutomationId -EQ 'scrollBarElement'
            | Get-ItemProperty -Name 'scroll.verticalviewsize'
        $actual.('Scroll.VerticalViewSize') | Should -Not -Be $null
        $actual.('Scroll.VerticalViewSize') | Should -Be $expected

    }

    It 'Gets multiple element properties at once' {
        $expectedRuntimeId = $testAppProc.UIWindow.GetCurrentPropertyValue([System.Windows.Automation.AutomationElement]::RuntimeIdProperty);
        $expectedBoundingRectangle = $testAppProc.UIWindow.GetCurrentPropertyValue([System.Windows.Automation.AutomationElement]::BoundingRectangleProperty);
        $actual = $testAppWindow | Get-ItemProperty -Name 'RuntimeId', 'BoundingRectangle'
        $actual.RuntimeId | Should -Be $expectedRuntimeId
        $actual.BoundingRectangle | Should -Be $expectedBoundingRectangle
    }

    It 'Gets item itself without name' {
        $testAppWindow | Get-ItemProperty | Should -Be $testAppWindow
    }
}