param([string]$OutputPath = (Join-Path $PSScriptRoot 'InputStatus.exe'))
$ErrorActionPreference = 'Stop'

$compiler = Join-Path $env:SystemRoot 'Microsoft.NET\Framework64\v4.0.30319\csc.exe'
if (-not (Test-Path -LiteralPath $compiler)) { throw "Missing C# compiler: $compiler" }
$source = Join-Path $PSScriptRoot 'InputStatus.cs'
& $compiler /nologo /target:exe /reference:System.Web.Extensions.dll "/out:$OutputPath" $source
if ($LASTEXITCODE -ne 0) { throw 'InputStatus compilation fails.' }
Write-Output "Built: $OutputPath"
