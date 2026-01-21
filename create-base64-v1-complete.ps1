# Create complete base64 embedded version of tools-competency-builders-v1.html

$htmlPath = "C:\Users\Isuru\Special Projects\tools-lms-section\tools-competency-builders-v1.html"
$outputPath = "C:\Users\Isuru\Special Projects\tools-lms-section\tools-competency-builders-v1-base64.html"
$buildersPath = "C:\Users\Isuru\Special Projects\tools-lms-section\builders\v1"
$creativesPath = "C:\Users\Isuru\Special Projects\tools-lms-section\creatives"

Write-Host "Reading HTML file..."
$html = Get-Content $htmlPath -Raw

# Convert GIF to base64
$gifPath = "$creativesPath\Tools feedback V2.gif"
if (Test-Path $gifPath) {
    Write-Host "Converting GIF to base64..."
    $gifBytes = [System.IO.File]::ReadAllBytes($gifPath)
    $gifBase64 = [System.Convert]::ToBase64String($gifBytes)
    $gifDataUrl = "data:image/gif;base64,$gifBase64"
    $html = $html -replace 'creatives/Tools feedback V2\.gif', $gifDataUrl
}

# Check if there's a heading image for v1
$headingPath = "$buildersPath\heading\Frame 181.png"
if (Test-Path $headingPath) {
    Write-Host "Converting heading image to base64..."
    $headingBytes = [System.IO.File]::ReadAllBytes($headingPath)
    $headingBase64 = [System.Convert]::ToBase64String($headingBytes)
    $headingDataUrl = "data:image/png;base64,$headingBase64"
    $html = $html -replace 'builders/v1/heading/Frame 181\.png', $headingDataUrl
}

# Convert all SVG files to base64 (Components 28-36)
for ($i = 28; $i -le 36; $i++) {
    Write-Host "Converting Component $i.svg to base64..."
    $svgPath = "$buildersPath\Component $i.svg"
    if (Test-Path $svgPath) {
        $svgBytes = [System.IO.File]::ReadAllBytes($svgPath)
        $svgBase64 = [System.Convert]::ToBase64String($svgBytes)
        $svgDataUrl = "data:image/svg+xml;base64,$svgBase64"
        $html = $html -replace "builders/v1/Component $i\.svg", $svgDataUrl
    }
}

Write-Host "Writing base64 HTML file..."
Set-Content -Path $outputPath -Value $html -NoNewline

Write-Host "Done! Created: $outputPath"
