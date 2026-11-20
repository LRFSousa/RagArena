param(
    [Parameter(Mandatory = $true)]
    [string]$Godot,
    [string]$Output = ""
)

$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
if ($Output -eq '') {
    $Output = Join-Path $projectRoot 'build/android/RagnArena-0.7.0-debug.apk'
}
$outputPath = [System.IO.Path]::GetFullPath($Output)
$outputDirectory = Split-Path -Parent $outputPath
New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null

& $Godot --headless --path $projectRoot --export-debug Android $outputPath
if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $outputPath)) {
    throw "A exportação Android falhou (código $LASTEXITCODE)."
}

$apk = Get-Item -LiteralPath $outputPath
$hash = Get-FileHash -LiteralPath $outputPath -Algorithm SHA256
Write-Output "APK: $($apk.FullName)"
Write-Output "Tamanho: $($apk.Length) bytes"
Write-Output "SHA-256: $($hash.Hash)"
