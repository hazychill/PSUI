Describe 'Get-Item of PSUI' {
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

    It 'Gets application window under root element' {
        Get-ChildItem -LiteralPath 'UI:\' | Where-Object {
            $_ -eq $testAppProc.UIWindow
        } | Should -HaveCount 1
    }

    It 'Gets child elements of application window' {
        $childItems = Get-ChildItem -LiteralPath $testAppWindow.PSPath
        $childItems | Should -Contain $testAppProc.UILabel
        $childItems | Should -Contain $testAppProc.UITextBox
        $childItems | Should -Contain $testAppProc.UIButton
        $childItems | Should -Contain $testAppProc.UIScrollBar
        $childItems | Should -Contain $testAppProc.UITreeView
    }

    It 'Filters child with name property' {
        Get-ChildItem -LiteralPath $testAppWindow.PSPath -UIName 'label' | Should -Be $testAppProc.UILabel
    }

    It 'Filters child with control type' {
        Get-ChildItem -LiteralPath $testAppWindow.PSPath -UIControlType 'Edit' | Should -Be $testAppProc.UITextBox
        Get-ChildItem -LiteralPath $testAppWindow.PSPath -UIControlType 'ControlType.Edit' | Should -Be $testAppProc.UITextBox
        Get-ChildItem -LiteralPath $testAppWindow.PSPath -UIControlType 'edit' | Should -Be $testAppProc.UITextBox
        Get-ChildItem -LiteralPath $testAppWindow.PSPath -UIControlType 'controltype.edit' | Should -Be $testAppProc.UITextBox
    }

    It 'Filters child with name and control type' {
        Get-ChildItem -LiteralPath $testAppWindow.PSPath -UIName 'button' -UIControlType 'Button' | Should -Be $testAppProc.UIButton

        Get-ChildItem -LiteralPath $testAppWindow.PSPath -UIControlType 'Tree' | Should -Be $testAppProc.UITreeView
        Get-ChildItem -LiteralPath $testAppWindow.PSPath -UIName 'xxx' -UIControlType 'Tree' | Should -Be $null
    }

    It 'Filters child with custom condition' {
        $cond = [System.Windows.Automation.OrCondition]::new(@(
            [System.Windows.Automation.PropertyCondition]::new([System.Windows.Automation.AutomationElement]::NameProperty, 'label')
            [System.Windows.Automation.PropertyCondition]::new([System.Windows.Automation.AutomationElement]::ControlTypeProperty, [System.Windows.Automation.ControlType]::Edit)
        ))

        $childElements = Get-ChildItem -LiteralPath $testAppWindow.PSPath -UICondition $cond
        $childElements | Should -HaveCount 2
        $childElements | Should -Contain $testAppProc.UILabel
        $childElements | Should -Contain $testAppProc.UITextBox
    }

    It 'Gets child recursively' {
        Set-Location -LiteralPath 'UI:\'
        $tree = $testAppWindow | Get-ChildItem -UIControlType 'Tree'
        $childElements = $tree | Get-ChildItem -Recurse | Get-AutomationIdProperty
        @(
            'treeViewItem1'
            'treeViewItem1_1'
            'treeViewItem1_2'
            'treeViewItem1_3'
            'treeViewItem2'
            'treeViewItem2_1'
            'treeViewItem2_2'
            'treeViewItem2_3'
            'treeViewItem3'
            'treeViewItem3_1'
            'treeViewItem3_1_1'
            'treeViewItem3_1_2'
            'treeViewItem3_2'
            'treeViewItem3_3'
        ) | ForEach-Object {
            $childElements | Should -Contain $_
        }
    }

    It 'Gets child recursively with depth' {
        Set-Location -LiteralPath 'UI:\'
        $tree = $testAppWindow | Get-ChildItem -UIControlType 'Tree'
        $childElements = $tree | Get-ChildItem -Depth 1 | Get-AutomationIdProperty
        @(
            'treeViewItem1'
            'treeViewItem1_1'
            'treeViewItem1_2'
            'treeViewItem1_3'
            'treeViewItem2'
            'treeViewItem2_1'
            'treeViewItem2_2'
            'treeViewItem2_3'
            'treeViewItem3'
            'treeViewItem3_1'
            'treeViewItem3_2'
            'treeViewItem3_3'
        ) | ForEach-Object {
            $childElements | Should -Contain $_
        }
        @(
            'treeViewItem3_1_1'
            'treeViewItem3_1_2'
        ) | ForEach-Object {
            $childElements | Should -Not -Contain $_
        }
    }
}