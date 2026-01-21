$basePath = "C:\Users\Isuru\Special Projects\tools-lms-section"

Write-Host "Step 1: Encoding all assets to base64..." -ForegroundColor Cyan

# Function to convert file to base64 data URI
function ConvertTo-DataUri {
    param($filePath)
    
    if (-not (Test-Path $filePath)) {
        Write-Host "WARNING: File not found: $filePath" -ForegroundColor Yellow
        return ""
    }
    
    $bytes = [System.IO.File]::ReadAllBytes($filePath)
    $base64 = [System.Convert]::ToBase64String($bytes)
    
    $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
    $mimeType = switch ($ext) {
        ".svg" { "image/svg+xml" }
        ".gif" { "image/gif" }
        ".png" { "image/png" }
        ".jpg" { "image/jpeg" }
        ".jpeg" { "image/jpeg" }
        ".mp4" { "video/mp4" }
        default { "application/octet-stream" }
    }
    
    return "data:$mimeType;base64,$base64"
}

# Encode all assets for v12-swinburne
Write-Host "`nEncoding assets for v12-swinburne..." -ForegroundColor Green
$html_v12_swin = Get-Content (Join-Path $basePath "tools-competency-v12-swinburne.html") -Raw

$html_v12_swin = $html_v12_swin -replace 'file: "Finalised SVGs/Component 9.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'Finalised SVGs\Component 9.svg'))`""
$html_v12_swin = $html_v12_swin -replace 'file: "Finalised SVGs/Component 10.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'Finalised SVGs\Component 10.svg'))`""
$html_v12_swin = $html_v12_swin -replace 'file: "Finalised SVGs/For Swinburne/Component 18.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'Finalised SVGs\For Swinburne\Component 18.svg'))`""
$html_v12_swin = $html_v12_swin -replace 'file: "Finalised SVGs/Component 12.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'Finalised SVGs\Component 12.svg'))`""
$html_v12_swin = $html_v12_swin -replace 'file: "Finalised SVGs/Component 13-new.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'Finalised SVGs\Component 13-new.svg'))`""
$html_v12_swin = $html_v12_swin -replace 'file: "Finalised SVGs/Updated Component 14/Component 14.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'Finalised SVGs\Updated Component 14\Component 14.svg'))`""
$html_v12_swin = $html_v12_swin -replace 'file: "Finalised SVGs/Component 15.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'Finalised SVGs\Component 15.svg'))`""
$html_v12_swin = $html_v12_swin -replace 'file: "Finalised SVGs/Component 16.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'Finalised SVGs\Component 16.svg'))`""
$html_v12_swin = $html_v12_swin -replace 'file: "Finalised SVGs/Component 17.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'Finalised SVGs\Component 17.svg'))`""
$html_v12_swin = $html_v12_swin -replace 'src: "Finalised SVGs/Partners/Frame 17.svg"', "src: `"$(ConvertTo-DataUri (Join-Path $basePath 'Finalised SVGs\Partners\Frame 17.svg'))`""
$html_v12_swin = $html_v12_swin -replace 'src: "Finalised SVGs/Video placeholder/68.svg"', "src: `"$(ConvertTo-DataUri (Join-Path $basePath 'Finalised SVGs\Video placeholder\68.svg'))`""
$html_v12_swin = $html_v12_swin -replace 'src: "creatives/Tools feedback V2.gif"', "src: `"$(ConvertTo-DataUri (Join-Path $basePath 'creatives\Tools feedback V2.gif'))`""

$html_v12_swin | Out-File (Join-Path $basePath "base64-embeds\tools-competency-v12-swinburne-base64.html") -Encoding UTF8
Write-Host "Created tools-competency-v12-swinburne-base64.html" -ForegroundColor Green

# Encode all assets for v12
Write-Host "`nEncoding assets for v12..." -ForegroundColor Green
$html_v12 = Get-Content (Join-Path $basePath "tools-competency-v12.html") -Raw

$html_v12 = $html_v12 -replace 'file: "Finalised SVGs/Component 9.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'Finalised SVGs\Component 9.svg'))`""
$html_v12 = $html_v12 -replace 'file: "Finalised SVGs/Component 10.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'Finalised SVGs\Component 10.svg'))`""
$html_v12 = $html_v12 -replace 'file: "Finalised SVGs/Component 11.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'Finalised SVGs\Component 11.svg'))`""
$html_v12 = $html_v12 -replace 'file: "Finalised SVGs/Component 12.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'Finalised SVGs\Component 12.svg'))`""
$html_v12 = $html_v12 -replace 'file: "Finalised SVGs/Component 13-new.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'Finalised SVGs\Component 13-new.svg'))`""
$html_v12 = $html_v12 -replace 'file: "Finalised SVGs/Updated Component 14/Component 14.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'Finalised SVGs\Updated Component 14\Component 14.svg'))`""
$html_v12 = $html_v12 -replace 'file: "Finalised SVGs/Component 15.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'Finalised SVGs\Component 15.svg'))`""
$html_v12 = $html_v12 -replace 'file: "Finalised SVGs/Component 16.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'Finalised SVGs\Component 16.svg'))`""
$html_v12 = $html_v12 -replace 'file: "Finalised SVGs/Component 17.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'Finalised SVGs\Component 17.svg'))`""
$html_v12 = $html_v12 -replace 'src: "Finalised SVGs/Partners/Frame 17.svg"', "src: `"$(ConvertTo-DataUri (Join-Path $basePath 'Finalised SVGs\Partners\Frame 17.svg'))`""
$html_v12 = $html_v12 -replace 'src: "Finalised SVGs/Video placeholder/68.svg"', "src: `"$(ConvertTo-DataUri (Join-Path $basePath 'Finalised SVGs\Video placeholder\68.svg'))`""
$html_v12 = $html_v12 -replace 'src: "creatives/Tools feedback V2.gif"', "src: `"$(ConvertTo-DataUri (Join-Path $basePath 'creatives\Tools feedback V2.gif'))`""

$html_v12 | Out-File (Join-Path $basePath "base64-embeds\tools-competency-v12-base64.html") -Encoding UTF8
Write-Host "Created tools-competency-v12-base64.html" -ForegroundColor Green

# Encode all assets for builders-v1
Write-Host "`nEncoding assets for builders-v1..." -ForegroundColor Green
$html_builders = Get-Content (Join-Path $basePath "tools-competency-builders-v1.html") -Raw

$html_builders = $html_builders -replace 'file: "builders/v1/Component 28.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'builders\v1\Component 28.svg'))`""
$html_builders = $html_builders -replace 'file: "builders/v1/Component 29.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'builders\v1\Component 29.svg'))`""
$html_builders = $html_builders -replace 'file: "builders/v1/Component 30.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'builders\v1\Component 30.svg'))`""
$html_builders = $html_builders -replace 'file: "builders/v1/Component 31.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'builders\v1\Component 31.svg'))`""
$html_builders = $html_builders -replace 'file: "builders/v1/Component 32.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'builders\v1\Component 32.svg'))`""
$html_builders = $html_builders -replace 'file: "builders/v1/Component 33.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'builders\v1\Component 33.svg'))`""
$html_builders = $html_builders -replace 'file: "builders/v1/Component 34.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'builders\v1\Component 34.svg'))`""
$html_builders = $html_builders -replace 'file: "builders/v1/Component 35.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'builders\v1\Component 35.svg'))`""
$html_builders = $html_builders -replace 'file: "builders/v1/Component 36.svg"', "file: `"$(ConvertTo-DataUri (Join-Path $basePath 'builders\v1\Component 36.svg'))`""
$html_builders = $html_builders -replace 'src: "creatives/Tools feedback V2.gif"', "src: `"$(ConvertTo-DataUri (Join-Path $basePath 'creatives\Tools feedback V2.gif'))`""

$html_builders | Out-File (Join-Path $basePath "base64-embeds\tools-competency-builders-v1-base64.html") -Encoding UTF8
Write-Host "Created tools-competency-builders-v1-base64.html" -ForegroundColor Green

Write-Host "`nAll base64 embedded versions created successfully!" -ForegroundColor Cyan
Write-Host "Files are in the base64-embeds folder" -ForegroundColor Yellow
