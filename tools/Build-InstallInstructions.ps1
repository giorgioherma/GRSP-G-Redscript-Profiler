$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$templatePath = Join-Path $repoRoot 'Install_Instructions.template.html'
$outputPath = Join-Path $repoRoot 'Install_Instructions.html'

$html = Get-Content -LiteralPath $templatePath -Raw

$images = [ordered]@{
    '@@IMG_CAPFRAMEX@@' = 'docs\\install-guide\\capframex.webp.b64'
    '@@IMG_SETUP@@' = 'docs\\install-guide\\setup.webp.b64'
    '@@IMG_INSTALL@@' = 'docs\\install-guide\\install.webp.b64'
    '@@IMG_READY@@' = 'docs\\install-guide\\ready.webp.b64'
    '@@IMG_CAPTURED@@' = 'docs\\install-guide\\captured.webp.b64'
    '@@IMG_COLLECTED@@' = 'docs\\install-guide\\collected.webp.b64'
}

foreach ($entry in $images.GetEnumerator()) {
    $assetPath = Join-Path $repoRoot $entry.Value
    if (!(Test-Path -LiteralPath $assetPath -PathType Leaf)) {
        throw "Install-guide image payload is missing: $assetPath"
    }

    $base64 = (Get-Content -LiteralPath $assetPath -Raw).Trim()
    if ([string]::IsNullOrWhiteSpace($base64)) {
        throw "Install-guide image payload is empty: $assetPath"
    }

    $html = $html.Replace($entry.Key, "data:image/webp;base64,$base64")
}

if ($html -match '@@IMG_[A-Z]+@@') {
    throw 'Install guide still contains unresolved image placeholders.'
}

Set-Content -LiteralPath $outputPath -Value $html -Encoding utf8 -NoNewline
Write-Host "Generated $outputPath"
