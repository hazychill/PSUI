---
external help file: PSUI.dll-Help.xml
Module Name: PSUI
online version:
schema: 2.0.0
---

# New-UICondition

## SYNOPSIS
Create a Condition object to search for UI elements.

## SYNTAX

### property
```
New-UICondition [[-Property] <AutomationProperty>] [-Eq] [[-PropertyValue] <Object>]
 [[-PropertyFlags] <PropertyConditionFlags>] [<CommonParameters>]
```

### not
```
New-UICondition [-Not] [[-Condition] <Condition>] [<CommonParameters>]
```

### and
```
New-UICondition [[-Condition] <Condition>] [-And] [[-AdditionalCondition] <Condition>] [<CommonParameters>]
```

### or
```
New-UICondition [[-Condition] <Condition>] [-Or] [[-AdditionalCondition] <Condition>] [<CommonParameters>]
```

### true
```
New-UICondition [-True] [<CommonParameters>]
```

### false
```
New-UICondition [-False] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS UI:\> $cond1 = New-UICondition Name -Eq 'PowerShell 7 (x64)'
PS UI:\> $cond2 = New-UICondition ControlType -Eq ([System.Windows.Automation.ControlType]::Window)
PS UI:\> $cond = New-UICondition $cond1 -And $cond2
PS UI:\> Get-ChildItem -UICondition $cond
```

Create a `Condition` whose `Name` property is "PowerShell 7 (x64)" and `ControlType` property is `Window`, and use it to search for UI elements.

## PARAMETERS

### -AdditionalCondition
A second `Condition` that combines with the `And` and `Or` properties

```yaml
Type: Condition
Parameter Sets: and, or
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -And
Combine two `Condition` with an AND condition.

```yaml
Type: SwitchParameter
Parameter Sets: and
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Condition
`Condition` used when creating a logical condition

```yaml
Type: Condition
Parameter Sets: not, and, or
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Eq
Specified when creating a `Condition` based on the property value.

```yaml
Type: SwitchParameter
Parameter Sets: property
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -False
Create a `Condition` that always returns `false`.

```yaml
Type: SwitchParameter
Parameter Sets: false
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Not
Create a `Condition` for the NOT condition of the given `Condition`.

```yaml
Type: SwitchParameter
Parameter Sets: not
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Or
Combine two `Condition` with an AND condition.

```yaml
Type: SwitchParameter
Parameter Sets: or
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Property
Property name when creating a `Condition` based on the property value.

```yaml
Type: AutomationProperty
Parameter Sets: property
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertyFlags
`PropertyConditionFlags` when creating a `Condition` based on property values

```yaml
Type: PropertyConditionFlags
Parameter Sets: property
Aliases:
Accepted values: None, IgnoreCase

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertyValue
Property value when creating a `Condition` based on property values

```yaml
Type: Object
Parameter Sets: property
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -True
Create a `Condition` that always returns `true`.

```yaml
Type: SwitchParameter
Parameter Sets: true
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Management.Automation.CommandOrigin

## NOTES

## RELATED LINKS

[Condition class](https://learn.microsoft.com/dotnet/api/system.windows.automation.condition)

[Find a UI Automation Element Based on a Property Condition](https://learn.microsoft.com/dotnet/framework/ui-automation/find-a-ui-automation-element-based-on-a-property-condition)
