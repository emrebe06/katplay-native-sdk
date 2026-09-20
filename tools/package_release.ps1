# Assembles a KatPlay SDK release from freshly built runtimes.
#
#   .\tools\package_release.ps1 -Version 0.4.0-alpha.1
#
# Binaries are stripped, copied into platforms/, checksummed per platform, and
# archived into release/ in the layout every previous release used. Signing is
# a separate, deliberate step:
#
#   ssh-keygen -Y sign -f $HOME\.ssh\<key> -n file release\SHA256SUMS-<ver>.txt

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Version,
    [string]$BuildRoot = 'L:\kattplay',
    [string]$MingwStrip = 'C:\DevTools\winlibs\mingw64\bin\strip.exe',
    [string]$LlvmStrip = "$env:LOCALAPPDATA\Programs\DevTools\android-sdk\ndk\28.2.13676358\toolchains\llvm\prebuilt\windows-x86_64\bin\llvm-strip.exe"
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$release = Join-Path $root 'release'
$header = Join-Path $BuildRoot 'include\kattplay\CApi.h'
New-Item -ItemType Directory -Force $release | Out-Null

$platforms = @(
    @{ Name = 'windows-x86_64';    Built = "$BuildRoot\build_a4_win\kattplay_runtime.dll";                 File = 'kattplay_runtime.dll';    Strip = $MingwStrip },
    @{ Name = 'linux-x86_64';      Built = "$BuildRoot\build_a4_linux\libkattplay_runtime.so";             File = 'libkattplay_runtime.so';  Strip = $LlvmStrip },
    @{ Name = 'android-arm64-v8a'; Built = "$BuildRoot\build_a4_android\libkattplay.so";                   File = 'libkattplay.so';          Strip = $LlvmStrip }
)

function Write-Sha256File {
    param([string]$Directory, [string[]]$Files, [string]$OutFile)
    $lines = foreach ($name in ($Files | Sort-Object)) {
        $hash = (Get-FileHash -LiteralPath (Join-Path $Directory $name) -Algorithm SHA256).Hash.ToLower()
        "$hash  $name"
    }
    # LF endings and a trailing newline, so sha256sum -c reads it on any platform.
    [IO.File]::WriteAllText($OutFile, ($lines -join "`n") + "`n", (New-Object Text.UTF8Encoding $false))
}

foreach ($platform in $platforms) {
    if (-not (Test-Path -LiteralPath $platform.Built)) { throw "Missing build output: $($platform.Built)" }
    $dir = Join-Path $root "platforms\$($platform.Name)"
    $target = Join-Path $dir $platform.File
    Copy-Item -LiteralPath $platform.Built -Destination $target -Force
    Copy-Item -LiteralPath $header -Destination (Join-Path $dir 'CApi.h') -Force
    & $platform.Strip '--strip-unneeded' $target
    if ($LASTEXITCODE -ne 0) { throw "strip failed for $($platform.Name)" }
    Write-Sha256File -Directory $dir -Files @('CApi.h', $platform.File) -OutFile (Join-Path $dir 'SHA256SUMS.txt')
    "{0,-20} {1,10:N0} bytes" -f $platform.Name, (Get-Item -LiteralPath $target).Length
}
Copy-Item -LiteralPath $header -Destination (Join-Path $root 'include\kattplay\CApi.h') -Force

$rootDocs = @('COMMERCIAL_USE.md', 'KNOWN_ISSUES.md', 'LICENSE.md', 'SECURITY.md', 'THIRD_PARTY_NOTICES.md')
$staging = Join-Path ([IO.Path]::GetTempPath()) "katplay-package-$Version"
if (Test-Path -LiteralPath $staging) { Remove-Item -LiteralPath $staging -Recurse -Force }

$archives = @()
foreach ($platform in $platforms) {
    $stage = Join-Path $staging $platform.Name
    New-Item -ItemType Directory -Force (Join-Path $stage $platform.Name) | Out-Null
    Copy-Item -Path (Join-Path $root "platforms\$($platform.Name)\*") -Destination (Join-Path $stage $platform.Name) -Recurse -Force
    foreach ($doc in $rootDocs) { Copy-Item -LiteralPath (Join-Path $root $doc) -Destination $stage -Force }

    if ($platform.Name -eq 'linux-x86_64') {
        $archive = Join-Path $release "KatPlay-$Version-$($platform.Name).tar.gz"
        tar -czf $archive -C $stage .
    } else {
        $archive = Join-Path $release "KatPlay-$Version-$($platform.Name).zip"
        if (Test-Path -LiteralPath $archive) { Remove-Item -LiteralPath $archive -Force }
        Compress-Archive -Path (Join-Path $stage '*') -DestinationPath $archive
    }
    $archives += Split-Path -Leaf $archive
}

$examplesStage = Join-Path $staging 'examples-package'
New-Item -ItemType Directory -Force $examplesStage | Out-Null
Copy-Item -Path (Join-Path $root 'docs') -Destination $examplesStage -Recurse -Force
Copy-Item -Path (Join-Path $root 'examples') -Destination $examplesStage -Recurse -Force
Copy-Item -Path (Join-Path $root 'include') -Destination $examplesStage -Recurse -Force
# Build leftovers from the .NET sample have no place in a release archive.
Get-ChildItem -LiteralPath $examplesStage -Recurse -Directory |
    Where-Object { $_.Name -in @('obj', 'bin') } |
    ForEach-Object { Remove-Item -LiteralPath $_.FullName -Recurse -Force -ErrorAction SilentlyContinue }
foreach ($doc in $rootDocs) { Copy-Item -LiteralPath (Join-Path $root $doc) -Destination $examplesStage -Force }
$examplesArchive = Join-Path $release "KatPlay-$Version-integration-examples.zip"
if (Test-Path -LiteralPath $examplesArchive) { Remove-Item -LiteralPath $examplesArchive -Force }
Compress-Archive -Path (Join-Path $examplesStage '*') -DestinationPath $examplesArchive
$archives += Split-Path -Leaf $examplesArchive

Write-Sha256File -Directory $release -Files $archives -OutFile (Join-Path $release "SHA256SUMS-$Version.txt")
Remove-Item -LiteralPath $staging -Recurse -Force

Get-ChildItem -LiteralPath $release -Filter "KatPlay-$Version-*" | Select-Object Name, Length
Get-Content -LiteralPath (Join-Path $release "SHA256SUMS-$Version.txt")
