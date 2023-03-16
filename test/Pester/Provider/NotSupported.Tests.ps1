Describe 'Cmdlets that is not supported by UIProvider by design' {
    BeforeAll {
        $ErrorActionPreference = 'Stop'
        . (Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath 'Util.ps1')
        Import-PSUIModule
    }

    AfterAll {
        Set-Location -LiteralPath 'Temp:\'
        Get-Module -Name 'PSUI' | Remove-Module
    }

    It 'Clear-Item is not supported' {
        { Get-ChildItem -LiteralPath 'UI:\' | Select-Object -First 1 | Clear-Item } | Should -Throw -ErrorId 'NotSupported,Microsoft.PowerShell.Commands.ClearItemCommand'
    }

    It 'Copy-Item is not supported' {
        { Get-ChildItem -LiteralPath 'UI:\' | Select-Object -First 1 | Copy-Item -Destination 'UI::ROOT\1.2.3' } | Should -Throw -ErrorId 'NotSupported,Microsoft.PowerShell.Commands.CopyItemCommand'
    }

    It 'Invoke-Item is not supported' {
        { Get-ChildItem -LiteralPath 'UI:\' | Select-Object -First 1 | Invoke-Item } | Should -Throw -ErrorId 'NotSupported,Microsoft.PowerShell.Commands.InvokeItemCommand'
    }

    It 'Move-Item is not supported' {
        { Get-ChildItem -LiteralPath 'UI:\' | Select-Object -First 1 | Move-Item -Destination 'UI:\' } | Should -Throw -ErrorId 'NotSupported,Microsoft.PowerShell.Commands.MoveItemCommand'
    }

    It 'New-ItemProperty is not supported' {
        $uiElement = Get-ChildItem -LiteralPath 'UI:\' | Select-Object -First 1
        { New-ItemProperty -LiteralPath $uiElement.PSPath -Name 'xxx' -Value 'yyy' } | Should -Throw -ErrorId 'NotSupported,Microsoft.PowerShell.Commands.NewItemPropertyCommand'
    }

    It 'Remove-Item is not supported' {
        { Get-ChildItem -LiteralPath 'UI:\' | Select-Object -First 1 | Remove-Item -Recurse } | Should -Throw -ErrorId 'NotSupported,Microsoft.PowerShell.Commands.RemoveItemCommand'
    }

    It 'Rename-Item is not supported' {
        { Get-ChildItem -LiteralPath 'UI:\' | Select-Object -First 1 | Rename-Item -NewName 'xxx' } | Should -Throw -ErrorId 'NotSupported,Microsoft.PowerShell.Commands.RenameItemCommand'
    }

    It 'Set-Item is not supported' {
        { Set-Item -LiteralPath 'UI:\1,2,3' -Value 'abc' } | Should -Throw -ErrorId 'NotSupported,Microsoft.PowerShell.Commands.SetItemCommand'
    }

    It 'Add-Content is not supported' {
        $uiElement = Get-ChildItem -LiteralPath 'UI:\' | Select-Object -First 1
        { Add-Content -LiteralPath $uiElement.PSPath -Value 'xxx' } | Should -Throw -ErrorId 'NotSupported,Microsoft.PowerShell.Commands.AddContentCommand'
    }

    It 'Clear-Content is not supported' {
        $uiElement = Get-ChildItem -LiteralPath 'UI:\' | Select-Object -First 1
        { Clear-Content -LiteralPath $uiElement.PSPath } | Should -Throw -ErrorId 'NotSupported,Microsoft.PowerShell.Commands.ClearContentCommand'
    }

    It 'Set-Content is not supported' {
        $uiElement = Get-ChildItem -LiteralPath 'UI:\' | Select-Object -First 1
        { Set-Content -LiteralPath $uiElement.PSPath -Value 'xxx' } | Should -Throw -ErrorId 'NotSupported,Microsoft.PowerShell.Commands.SetContentCommand'
    }

    It 'Clear-ItemProperty is not supported' {
        $uiElement = Get-ChildItem -LiteralPath 'UI:\' | Select-Object -First 1
        { Clear-ItemProperty -LiteralPath $uiElement.PSPath -Name 'xxx' } | Should -Throw -ErrorId 'ClearPropertyDynamicParametersProviderException'
    }

    It 'Copy-ItemProperty is not supported' {
        $uiElement1 = Get-ChildItem -LiteralPath 'UI:\' | Select-Object -First 1
        $uiElement2 = Get-ChildItem -LiteralPath 'UI:\' | Select-Object -First 2 | Select-Object -Last 1
        { Copy-ItemProperty -LiteralPath $uiElement1.PSPath -Name 'Name' -Destination $uiElement2.PSPath } | Should -Throw -ErrorId 'NotSupported,Microsoft.PowerShell.Commands.CopyItemPropertyCommand'
    }

    It 'Move-ItemProperty is not supported' {
        $uiElement1 = Get-ChildItem -LiteralPath 'UI:\' | Select-Object -First 1
        $uiElement2 = Get-ChildItem -LiteralPath 'UI:\' | Select-Object -First 2 | Select-Object -Last 1
        { Move-ItemProperty -LiteralPath $uiElement1.PSPath -Name 'Name' -Destination $uiElement2.PSPath } | Should -Throw -ErrorId 'NotSupported,Microsoft.PowerShell.Commands.MoveItemPropertyCommand'
    }

    It 'New-ItemProperty is not supported' {
        $uiElement = Get-ChildItem -LiteralPath 'UI:\' | Select-Object -First 1
        { New-ItemProperty -LiteralPath $uiElement.PSPath -Name 'xxx' -Value 'yyy' } | Should -Throw -ErrorId 'NotSupported,Microsoft.PowerShell.Commands.NewItemPropertyCommand'
    }

    It 'Remove-ItemProperty is not supported' {
        $uiElement = Get-ChildItem -LiteralPath 'UI:\' | Select-Object -First 1
        { Remove-ItemProperty -LiteralPath $uiElement.PSPath -Name 'xxx' } | Should -Throw -ErrorId 'NotSupported,Microsoft.PowerShell.Commands.RemoveItemPropertyCommand'
    }

    It 'Rename-ItemProperty is not supported' {
        $uiElement = Get-ChildItem -LiteralPath 'UI:\' | Select-Object -First 1
        { Rename-ItemProperty -LiteralPath $uiElement.PSPath -Name 'xxx' -NewName 'yyy' } | Should -Throw -ErrorId 'NotSupported,Microsoft.PowerShell.Commands.RenameItemPropertyCommand'
    }

    It 'Set-ItemProperty is not supported' {
        $uiElement = Get-ChildItem -LiteralPath 'UI:\' | Select-Object -First 1
        { Set-ItemProperty -LiteralPath $uiElement.PSPath -Name 'xxx' -Value 'yyy' } | Should -Throw -ErrorId 'SetPropertyDynamicParametersProviderException'
    }
}