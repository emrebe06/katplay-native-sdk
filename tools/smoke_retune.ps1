# End-to-end check of the packaged Windows runtime: calls the shipped DLL the
# way an integrator would, then reports where the output actually landed.
#
#   .\tools\smoke_retune.ps1 -Source <wav> -Target 432

[CmdletBinding()]
param(
    # Not named -Input: that collides with PowerShell's automatic $Input.
    [Parameter(Mandatory = $true)][string]$Source,
    [double]$Target = 432.0,
    [double]$SourceReference = 0.0,
    [string]$Output = "$env:TEMP\katplay_smoke_retune.wav"
)

$ErrorActionPreference = 'Stop'
$dll = Join-Path (Split-Path -Parent $PSScriptRoot) 'platforms\windows-x86_64\kattplay_runtime.dll'
if (-not (Test-Path -LiteralPath $dll)) { throw "Runtime not found: $dll" }

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public static class KattPlaySmoke {
    [DllImport(@"$dll", CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Ansi)]
    public static extern int kattplay_retune_file_ex(byte[] input, byte[] output,
        double referenceHz, double sourceReferenceHz, byte[] error, UIntPtr errorSize);
    [DllImport(@"$dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern int kattplay_abi_version();
}
"@

function ToUtf8Bytes([string]$text) {
    $bytes = [Text.Encoding]::UTF8.GetBytes($text)
    return $bytes + [byte]0
}

$error = New-Object byte[] 512
$inputPath = (Resolve-Path -LiteralPath $Source).Path
if (Test-Path -LiteralPath $Output) { Remove-Item -LiteralPath $Output -Force }

$abi = [KattPlaySmoke]::kattplay_abi_version()
$ok = [KattPlaySmoke]::kattplay_retune_file_ex(
    (ToUtf8Bytes $inputPath), (ToUtf8Bytes $Output), $Target, $SourceReference,
    $error, [UIntPtr]::new(512))

$message = [Text.Encoding]::UTF8.GetString($error).TrimEnd([char]0)
"abi_version = $abi"
if ($ok -ne 1) { throw "kattplay_retune_file_ex failed: $message" }
"retuned -> $Output ({0:N0} bytes)" -f (Get-Item -LiteralPath $Output).Length
