function Get-PSUIModuleLocation {
    [CmdletBinding()]
    param ()

    Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath '..', 'build', 'PSUI', 'PSUI.psd1'
}

function Import-PSUIModule {
    [CmdletBinding()]
    param ()

    Import-Module -Name (Get-PSUIModuleLocation)
}

function Get-RuntimeIdProperty {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [System.Windows.Automation.AutomationElement]$Element
    )

    process {
        $Element.GetCurrentPropertyValue([System.Windows.Automation.AutomationElement]::RuntimeIdProperty)
    }
}

function Get-ProcessIdProperty {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [System.Windows.Automation.AutomationElement]$Element
    )

    process {
        $Element.GetCurrentPropertyValue([System.Windows.Automation.AutomationElement]::ProcessIdProperty)
    }
}

function Get-AutomationIdProperty {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [System.Windows.Automation.AutomationElement]$Element
    )

    process {
        $Element.GetCurrentPropertyValue([System.Windows.Automation.AutomationElement]::AutomationIdProperty)
    }
}

function Start-TestApp {
    [CmdletBinding()]
    param ()

    $filePath = Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath @('TestApp', 'bin', 'Debug', 'net7.0-windows', 'publish', 'TestApp.exe')
    $proc = Start-Process -FilePath $filePath -PassThru
    

    $cond = [System.Windows.Automation.PropertyCondition]::new([System.Windows.Automation.AutomationElement]::ProcessIdProperty, $proc.Id)

    $found = 1..10 | ForEach-Object {
        $item = [System.Windows.Automation.AutomationElement]::RootElement.FindFirst([System.Windows.Automation.TreeScope]::Children, $cond)
        if ($null -ne $item) {
            $true
        }
        else {
            Start-Sleep -Seconds 1
            $false
        }
    }
    | Where-Object { $_ } | Select-Object -First 1

    if (-not $found) {
        throw 'Start-TestApp error'
    }

    $testAppWindow = [System.Windows.Automation.AutomationElement]::RootElement.FindFirst(
        [System.Windows.Automation.TreeScope]::Children,
        [System.Windows.Automation.PropertyCondition]::new([System.Windows.Automation.AutomationElement]::ProcessIdProperty, $proc.Id))
    $testAppWindowPath = "UI::ROOT\$($testAppWindow.GetCurrentPropertyValue([System.Windows.Automation.AutomationElement]::RuntimeIdProperty) -join ',')"
    $label = $testAppWindow.FindFirst(
        [System.Windows.Automation.TreeScope]::Children,
        [System.Windows.Automation.PropertyCondition]::new([System.Windows.Automation.AutomationElement]::AutomationIdProperty, 'labelElement'))
    $textBox = $testAppWindow.FindFirst(
        [System.Windows.Automation.TreeScope]::Children,
        [System.Windows.Automation.PropertyCondition]::new([System.Windows.Automation.AutomationElement]::AutomationIdProperty, 'textBoxElement'))
    $button = $testAppWindow.FindFirst(
        [System.Windows.Automation.TreeScope]::Children,
        [System.Windows.Automation.PropertyCondition]::new([System.Windows.Automation.AutomationElement]::AutomationIdProperty, 'buttonElement'))
    $scrollBar = $testAppWindow.FindFirst(
        [System.Windows.Automation.TreeScope]::Children,
        [System.Windows.Automation.PropertyCondition]::new([System.Windows.Automation.AutomationElement]::AutomationIdProperty, 'scrollBarElement'))
    $treeView = $testAppWindow.FindFirst(
        [System.Windows.Automation.TreeScope]::Children,
        [System.Windows.Automation.PropertyCondition]::new([System.Windows.Automation.AutomationElement]::AutomationIdProperty, 'treeViewElement'))

    $proc
    | Add-Member -MemberType NoteProperty -Name UIWindow -Value $testAppWindow -PassThru
    | Add-Member -MemberType NoteProperty -Name UIWindowPath -Value $testAppWindowPath -PassThru
    | Add-Member -MemberType NoteProperty -Name UILabel -Value $label -PassThru
    | Add-Member -MemberType NoteProperty -Name UITextBox -Value $textBox -PassThru
    | Add-Member -MemberType NoteProperty -Name UIButton -Value $button -PassThru
    | Add-Member -MemberType NoteProperty -Name UIScrollBar -Value $scrollBar -PassThru
    | Add-Member -MemberType NoteProperty -Name UITreeView -Value $treeView -PassThru
}

function Get-ChildUIElement {
    [CmdletBinding()]
    param (
        [System.Windows.Automation.AutomationElement]$Parent
    )

    $Parent.FindAll([System.Windows.Automation.TreeScope]::Children, [System.Windows.Automation.Condition]::TrueCondition)
}

function Get-RootUIElement {
    [CmdletBinding()]
    param ()

    [System.Windows.Automation.AutomationElement]::RootElement
}
