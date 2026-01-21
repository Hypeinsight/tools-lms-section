$basePath = "C:\Users\Isuru\Special Projects\tools-lms-section"

# Encode SVGs
$svgs = @(
    "Finalised SVGs/Component 9.svg",
    "Finalised SVGs/Component 10.svg",
    "Finalised SVGs/Component 11.svg",
    "Finalised SVGs/Component 12.svg",
    "Finalised SVGs/Component 13.svg",
    "Finalised SVGs/Component 14.svg",
    "Finalised SVGs/Component 15.svg",
    "Finalised SVGs/Component 16.svg",
    "Finalised SVGs/Component 17.svg"
)

$output = @{}

foreach ($svg in $svgs) {
    $fullPath = Join-Path $basePath $svg
    $bytes = [System.IO.File]::ReadAllBytes($fullPath)
    $base64 = [Convert]::ToBase64String($bytes)
    $output[$svg] = "data:image/svg+xml;base64,$base64"
    Write-Host "Encoded: $svg"
}

# Encode GIF
$gifPath = Join-Path $basePath "creatives/Tools feedback V2.gif"
$gifBytes = [System.IO.File]::ReadAllBytes($gifPath)
$gifBase64 = [Convert]::ToBase64String($gifBytes)
$output["creatives/Tools feedback V2.gif"] = "data:image/gif;base64,$gifBase64"
Write-Host "Encoded: GIF"

# Output as JSON
$output | ConvertTo-Json | Out-File (Join-Path $basePath "encoded-assets.json")
Write-Host "Done! Saved to encoded-assets.json"
