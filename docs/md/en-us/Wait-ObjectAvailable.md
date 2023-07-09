---
external help file: PSUI.dll-Help.xml
Module Name: PSUI
online version:
schema: 2.0.0
---

# Wait-ObjectAvailable

## SYNOPSIS
Wait until ScriptBlock returns a positive value.

## SYNTAX

```
Wait-ObjectAvailable [-ScriptBlock] <ScriptBlock> [-TimeOut <TimeSpan>] [-Interval <TimeSpan>]
 [<CommonParameters>]
```

## DESCRIPTION
Executes the passed ScriptBlock repeatedly at the specified interval. Execution ends when ScriptBlock returns a positive value. A "positive value" as used herein means neither of the following. (1) null, (2) false, (3) Exception, (4) ErrorRecord, (5) empty pipeline.

## EXAMPLES

### Example 1
```powershell
PS UI:\> $psWindow = Wait-ObjectAvailable {
    Get-ChildItem -LiteralPath 'UI:\'
    | Where-Object Name -match 'PowerShell'
    | Select-Object -First 1
}
```

Wait until a window with "PowerShell" in its name appears.

## PARAMETERS

### -Interval
Interval to execute ScriptBlock.

```yaml
Type: TimeSpan
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScriptBlock
ScriptBlock to execute.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeOut
Waiting timeout time.

```yaml
Type: TimeSpan
Parameter Sets: (All)
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

### None

## OUTPUTS

### System.Object

The object written to the pipeline in the first ScriptBlock that returned a positive value.

## NOTES

## RELATED LINKS
