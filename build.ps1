[CmdletBinding()]
param (
    [ValidateSet('Debug', 'Release')]
    [string]$Configuration = 'Debug',
    [switch]$Clean
)

$ErrorActionPreference = 'Stop'

$buildDir = Join-Path -Path $PSScriptRoot -ChildPath 'build'

Get-ChildItem -LiteralPath $buildDir -Exclude '.dummy' | Remove-Item -Recurse -Verbose

$publishWorkDir = Join-Path -Path $buildDir -ChildPath 'publishWork'
[void](New-Item -Path $publishWorkDir -ItemType Directory)

$srcDir = Join-Path -Path $PSScriptRoot -ChildPath 'src'
Push-Location -LiteralPath $srcDir
try {
    if ($Clean) {
        & dotnet clean
    }
    & dotnet publish -c $Configuration -o $publishWorkDir
}
finally {
    Pop-Location
}