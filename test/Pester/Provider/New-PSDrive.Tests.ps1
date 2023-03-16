Describe 'New-PSDrive of PSUI' {
    BeforeAll {
        $ErrorActionPreference = 'Stop'
        . (Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath 'Util.ps1')
        Import-PSUIModule
    }

    AfterAll {
        Set-Location -LiteralPath 'Temp:\'
        Get-Module -Name 'PSUI' | Remove-Module
    }

    It 'Create new drive with UI item' {
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

        $rootElementRuntimeId = Get-RuntimeIdProperty -Element $rootElement
        $driveRootRuntimeId = Get-RuntimeIdProperty -Element (Get-Item -LiteralPath "${driveName}:\")
        $driveRootRuntimeId | Should -Not -Be $null
        $driveRootRuntimeId | Should -Be $rootElementRuntimeId
    }

    Context 'with TestApp' {
        BeforeAll {
            $testAppProc = Start-TestApp
        }

        AfterAll {
            $testAppProc | Stop-Process
        }

        It 'Create drive with restricted view that shows/hides scrollbar' -ForEach @(
            @{ View = 'Raw'; ExpectedItemCount = 1 }
            @{ View = 'Content'; ExpectedItemCount = 0 }
        ) {
            Set-Location -LiteralPath 'UI:\'
            $testAppWindow = $testAppProc.UIWindow
            $testAppWindow | Should -Not -Be $null
    
            $driveName = 'TestAppWindow'
            $drive = New-PSDrive -Name $driveName -PSProvider 'UI' -Root $testAppProc.UIWindowPath -UIView $View
            $drive | Should -Not -Be $null

            Get-ChildItem -LiteralPath "${driveName}:\"
            | Where-Object {
                (Get-AutomationIdProperty -Element $_) -eq 'scrollBarElement'
            }
            | Should -HaveCount $ExpectedItemCount
        }
    }
}