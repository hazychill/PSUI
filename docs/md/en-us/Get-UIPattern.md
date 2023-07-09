---
external help file: PSUI.dll-Help.xml
Module Name: PSUI
online version:
schema: 2.0.0
---

# Get-UIPattern

## SYNOPSIS
Get UI Automation control pattern from AutomationElement.


## SYNTAX

### patternObj (Default)
```
Get-UIPattern -AutomationElement <AutomationElement[]> [[-Pattern] <AutomationPattern>] [<CommonParameters>]
```

### supportedPattern
```
Get-UIPattern -AutomationElement <AutomationElement[]> [-SupportedPattern] [<CommonParameters>]
```

## DESCRIPTION
Get UI Automation control pattern from `AutomationElement`, or get a list of supported `AutomationPattern` objects currently implemented by `AutomationElement`.

## EXAMPLES

### Example 1
```powershell
PS UI:\> $uiElement | Get-UIPattern -Pattern Invoke
```

Get the `Invoke` pattern implemented in the `AutomationElement` stored in `$uiElement`.

### Example 2
```powershell
PS UI:\> $uiElement | Get-UIPattern -SupportedPattern
```

Get all `AutomationPatterns` supported by `AutomationElement` stored in `$uiElement`.

## PARAMETERS

### -AutomationElement
`AutomationElement` for which to get the pattern.

```yaml
Type: AutomationElement[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Pattern
`AutomationPattern` that identifies the pattern to get from the `AutomationElement`.

```yaml
Type: AutomationPattern
Parameter Sets: patternObj
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SupportedPattern
Specified when retrieving the list of supported patterns.

```yaml
Type: SwitchParameter
Parameter Sets: supportedPattern
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Windows.Automation.AutomationElement[]

## OUTPUTS

### System.Object
If the `Patten` parameter is specified.

### System.Windows.Automation.AutomationPattern
If the `SupportedPattern` parameter is specified.

## NOTES

## RELATED LINKS

[UI Automation Control Patterns Overview](https://learn.microsoft.com/dotnet/framework/ui-automation/ui-automation-control-patterns-overview)

[AutomationElement.GetCurrentPattern(AutomationPattern) Method](https://learn.microsoft.com/dotnet/api/system.windows.automation.automationelement.getcurrentpattern)

[AutomationElement.GetSupportedPatterns Method](https://learn.microsoft.com/dotnet/api/system.windows.automation.automationelement.getsupportedpatterns)