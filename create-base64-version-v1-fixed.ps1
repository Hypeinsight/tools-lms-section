# Create base64 embedded version of tools-competency-builders-v1.html with xlink fixes

$htmlPath = "C:\Users\Isuru\Special Projects\tools-lms-section\tools-competency-builders-v1.html"
$outputPath = "C:\Users\Isuru\Special Projects\tools-lms-section\tools-competency-builders-v1-base64.html"
$buildersPath = "C:\Users\Isuru\Special Projects\tools-lms-section\builders\v1"

Write-Host "Reading HTML file..."
$html = Get-Content $htmlPath -Raw

# Check if there's a heading image for v1
$headingPath = "$buildersPath\heading\Frame 181.png"
if (Test-Path $headingPath) {
    Write-Host "Converting heading image to base64..."
    $headingBytes = [System.IO.File]::ReadAllBytes($headingPath)
    $headingBase64 = [System.Convert]::ToBase64String($headingBytes)
    $headingDataUrl = "data:image/png;base64,$headingBase64"
    $html = $html -replace 'builders/v1/heading/Frame 181\.png', $headingDataUrl
}

# Convert all SVG files to base64 (Components 28-36) with xlink fixes
for ($i = 28; $i -le 36; $i++) {
    Write-Host "Converting Component $i.svg to base64..."
    $svgPath = "$buildersPath\Component $i.svg"
    if (Test-Path $svgPath) {
        # Read the SVG content
        $svgContent = Get-Content $svgPath -Raw
        
        # Fix xlink namespace issues for HubSpot compatibility
        # Replace xlink:href with href (modern SVG standard)
        $svgContent = $svgContent -replace 'xlink:href=', 'href='
        
        # Remove xmlns:xlink declaration if it exists (no longer needed)
        $svgContent = $svgContent -replace '\s+xmlns:xlink="[^"]*"', ''
        
        # Convert modified SVG to base64
        $svgBytes = [System.Text.Encoding]::UTF8.GetBytes($svgContent)
        $svgBase64 = [System.Convert]::ToBase64String($svgBytes)
        $svgDataUrl = "data:image/svg+xml;base64,$svgBase64"
        $html = $html -replace "builders/v1/Component $i\.svg", $svgDataUrl
    }
}

Write-Host "Writing base64 HTML file..."
Set-Content -Path $outputPath -Value $html -NoNewline

Write-Host "Done! Created: $outputPath"
Write-Host "This version has xlink:href replaced with href for better HubSpot compatibility"
