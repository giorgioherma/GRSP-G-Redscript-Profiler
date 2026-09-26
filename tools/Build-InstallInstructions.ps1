$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$templatePath = Join-Path $repoRoot 'Install_Instructions.template.html'
$outputPath = Join-Path $repoRoot 'Install_Instructions.html'

if (!(Test-Path -LiteralPath $templatePath -PathType Leaf)) {
    throw "Canonical install guide source is missing: $templatePath"
}

$html = Get-Content -LiteralPath $templatePath -Raw
if ([string]::IsNullOrWhiteSpace($html)) {
    throw 'Canonical install guide source is empty.'
}

if ($html -match '@@IMG_[A-Z]+@@') {
    throw 'Canonical install guide still contains legacy image placeholders.'
}

if ($html -match 'data:image/webp;base64') {
    throw 'Canonical install guide still contains legacy compressed WebP screenshots.'
}

if ($html -notmatch 'data:image/png;base64' -or $html -notmatch 'hardcoded F11') {
    throw 'Canonical install guide failed PNG/F11 validation.'
}

Set-Content -LiteralPath $outputPath -Value $html -Encoding utf8 -NoNewline
Write-Host "Generated $outputPath from the canonical self-contained guide"
