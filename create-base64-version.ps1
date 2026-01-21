# Create base64 embedded version of tools-competency-builders-v2.html

$htmlPath = "C:\Users\Isuru\Special Projects\tools-lms-section\tools-competency-builders-v2.html"
$outputPath = "C:\Users\Isuru\Special Projects\tools-lms-section\tools-competency-builders-v2-base64.html"
$buildersPath = "C:\Users\Isuru\Special Projects\tools-lms-section\builders\v2"

Write-Host "Reading HTML file..."
$html = Get-Content $htmlPath -Raw

# Convert heading PNG to base64
Write-Host "Converting heading image to base64..."
$headingPath = "$buildersPath\heading\Frame 181.png"
$headingBytes = [System.IO.File]::ReadAllBytes($headingPath)
$headingBase64 = [System.Convert]::ToBase64String($headingBytes)
$headingDataUrl = "data:image/png;base64,$headingBase64"
$html = $html -replace 'builders/v2/heading/Frame 181\.png', $headingDataUrl

# Convert all SVG files to base64
for ($i = 1; $i -le 14; $i++) {
    Write-Host "Converting Component $i.svg to base64..."
    $svgPath = "$buildersPath\Component $i.svg"
    $svgBytes = [System.IO.File]::ReadAllBytes($svgPath)
    $svgBase64 = [System.Convert]::ToBase64String($svgBytes)
    $svgDataUrl = "data:image/svg+xml;base64,$svgBase64"
    $html = $html -replace "builders/v2/Component $i\.svg", $svgDataUrl
}

Write-Host "Writing base64 HTML file..."
Set-Content -Path $outputPath -Value $html -NoNewline

Write-Host "Done! Created: $outputPath"
