$basePath = "C:\Users\Isuru\Special Projects\tools-lms-section"

# Read encoded assets
$encoded = Get-Content (Join-Path $basePath "encoded-assets.json") -Raw | ConvertFrom-Json

# Read the original HTML
$html = Get-Content (Join-Path $basePath "tools-competency-v11.html") -Raw

# Replace file paths with base64 data URIs
$html = $html -replace 'file: "Finalised SVGs/Component 9.svg"', "file: `"$($encoded.'Finalised SVGs/Component 9.svg')`""
$html = $html -replace 'file: "Finalised SVGs/Component 10.svg"', "file: `"$($encoded.'Finalised SVGs/Component 10.svg')`""
$html = $html -replace 'file: "Finalised SVGs/Component 11.svg"', "file: `"$($encoded.'Finalised SVGs/Component 11.svg')`""
$html = $html -replace 'file: "Finalised SVGs/Component 12.svg"', "file: `"$($encoded.'Finalised SVGs/Component 12.svg')`""
$html = $html -replace 'file: "Finalised SVGs/Component 13.svg"', "file: `"$($encoded.'Finalised SVGs/Component 13.svg')`""
$html = $html -replace 'file: "Finalised SVGs/Component 14.svg"', "file: `"$($encoded.'Finalised SVGs/Component 14.svg')`""
$html = $html -replace 'file: "Finalised SVGs/Component 15.svg"', "file: `"$($encoded.'Finalised SVGs/Component 15.svg')`""
$html = $html -replace 'file: "Finalised SVGs/Component 16.svg"', "file: `"$($encoded.'Finalised SVGs/Component 16.svg')`""
$html = $html -replace 'file: "Finalised SVGs/Component 17.svg"', "file: `"$($encoded.'Finalised SVGs/Component 17.svg')`""
$html = $html -replace 'src: "creatives/Tools feedback V2.gif"', "src: `"$($encoded.'creatives/Tools feedback V2.gif')`""

# Save the embedded HTML
$html | Out-File (Join-Path $basePath "tools-competency-v11-embedded.html") -Encoding UTF8

Write-Host "Done! Created tools-competency-v11-embedded.html"
