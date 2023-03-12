[CmdletBinding()]
param (
    [ValidateSet('Debug', 'Release')]
    [string]$Configuration = 'Release'
)

$ErrorActionPreference = 'Stop'

$BUILD_CONFIG = @{
    BuildDirName = 'build'
    SrcDirName = 'src'
    PublicDirName = 'publishWork'
    ResourcesDirName = 'resources'
    ModuleName = 'PSUI'
    TypesPs1xmlFileName = 'PSUI.Types.ps1xml'
    ManifestFileName = 'PSUI.psd1'
    ModuleVersionReplacePattern = '__PSUI_VERSION__'
    ModulePrereleasePattern = '__PSUI_PRERELEASE__'
}

function Get-PSUIVersion {
    [CmdletBinding()]
    [OutputType([version])]
    param ()

    [version]'0.0.1' | Add-Member -MemberType NoteProperty -Name Prerelease -Value 'alpha' -PassThru
}

# clean build directory
$psuiRoot = $PSScriptRoot
$buildDir = Join-Path -Path $psuiRoot -ChildPath $BUILD_CONFIG.buildDirName
Get-ChildItem -LiteralPath $buildDir -Exclude '.dummy' | Remove-Item -Recurse -Verbose

$srcDir = Join-Path -Path $psuiRoot -ChildPath $BUILD_CONFIG.SrcDirName
Push-Location -LiteralPath $srcDir
try {
    # create module output directory
    $moduleOutDir = Join-Path -Path $buildDir -ChildPath $BUILD_CONFIG.ModuleName
    [void](New-Item -Path $moduleOutDir -ItemType Directory)

    # clean and publish src
    & dotnet clean -o $moduleOutDir
    if ($? -eq $false) {
        throw "dot net clean failed"
    }
    $publishParams = @()
    if ($Configuration -eq 'Release') {
        $publishParams += @(
            '/p:DebugType=None'
            '/p:DebugSymbols=false'
        )
    }
    & dotnet publish -c $Configuration -o $moduleOutDir $publishParams
    if ($? -eq $false) {
        throw "dot net publish failed"
    }

    # copy types.ps1xml
    $resourceDir = Join-Path -Path $psuiRoot -ChildPath $BUILD_CONFIG.ResourcesDirName
    $typesPs1xmlFileName = "$($BUILD_CONFIG.ModuleName).Types.ps1xml"
    $typesPs1xml = Join-Path -Path $resourceDir -ChildPath $typesPs1xmlFileName
    Copy-Item -LiteralPath $typesPs1xml -Destination $moduleOutDir -Verbose

    # copy module manifest and embed version
    $version = Get-PSUIVersion
    $manifestFileName = "$($BUILD_CONFIG.ModuleName).psd1"
    $manifestSrc = Join-Path -Path $resourceDir -ChildPath $manifestFileName
    [System.IO.FileInfo]$manifest = Copy-Item -LiteralPath $manifestSrc -Destination $moduleOutDir -PassThru -Verbose
    $manifestContent = $manifest | Get-Content -Encoding utf8 -Raw
    $manifestContent = $manifestContent -replace $BUILD_CONFIG.ModuleVersionReplacePattern, ($version.ToString())
    $manifestContent = $manifestContent -replace $BUILD_CONFIG.ModulePrereleasePattern, ($version.Prerelease)
    Set-Content -LiteralPath $manifest.FullName -Value $manifestContent -Encoding utf8
    [void](Test-ModuleManifest -Path $manifest.FullName -Verbose)
}
finally {
    Pop-Location
}