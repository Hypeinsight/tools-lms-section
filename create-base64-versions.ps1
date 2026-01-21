# Script to create base64-embedded versions of HTML files
# This embeds all SVG and image files as data URIs

$ErrorActionPreference = "Stop"

function Convert-FileToBase64 {
    param(
        [string]$FilePath
    )
    $bytes = [System.IO.File]::ReadAllBytes($FilePath)
    $base64 = [System.Convert]::ToBase64String($bytes)
    
    # Determine MIME type
    $ext = [System.IO.Path]::GetExtension($FilePath).ToLower()
    $mimeType = switch ($ext) {
        ".svg" { "image/svg+xml" }
        ".gif" { "image/gif" }
        ".png" { "image/png" }
        ".jpg" { "image/jpeg" }
        ".jpeg" { "image/jpeg" }
        default { "application/octet-stream" }
    }
    
    return "data:$mimeType;base64,$base64"
}

# Define file mappings
$files = @{
    "Finalised SVGs/Component 9.svg" = "C:\Users\Isuru\Special Projects\tools-lms-section\Finalised SVGs\Component 9.svg"
    "Finalised SVGs/Component 10.svg" = "C:\Users\Isuru\Special Projects\tools-lms-section\Finalised SVGs\Component 10.svg"
    "Finalised SVGs/Component 11.svg" = "C:\Users\Isuru\Special Projects\tools-lms-section\Finalised SVGs\Component 11.svg"
    "Finalised SVGs/Component 12.svg" = "C:\Users\Isuru\Special Projects\tools-lms-section\Finalised SVGs\Component 12.svg"
    "Finalised SVGs/Component 13.svg" = "C:\Users\Isuru\Special Projects\tools-lms-section\Finalised SVGs\Component 13.svg"
    "Finalised SVGs/Component 14.svg" = "C:\Users\Isuru\Special Projects\tools-lms-section\Finalised SVGs\Component 14.svg"
    "Finalised SVGs/Component 15.svg" = "C:\Users\Isuru\Special Projects\tools-lms-section\Finalised SVGs\Component 15.svg"
    "Finalised SVGs/Component 16.svg" = "C:\Users\Isuru\Special Projects\tools-lms-section\Finalised SVGs\Component 16.svg"
    "Finalised SVGs/Component 17.svg" = "C:\Users\Isuru\Special Projects\tools-lms-section\Finalised SVGs\Component 17.svg"
    "Finalised SVGs/For Swinburne/Component 18.svg" = "C:\Users\Isuru\Special Projects\tools-lms-section\Finalised SVGs\For Swinburne\Component 18.svg"
    "Finalised SVGs/Partners/Frame 17.svg" = "C:\Users\Isuru\Special Projects\tools-lms-section\Finalised SVGs\Partners\Frame 17.svg"
    "Finalised SVGs/See Tools in Action/Group 14.svg" = "C:\Users\Isuru\Special Projects\tools-lms-section\Finalised SVGs\See Tools in Action\Group 14.svg"
    "Finalised SVGs/Video placeholder/68.svg" = "C:\Users\Isuru\Special Projects\tools-lms-section\Finalised SVGs\Video placeholder\68.svg"
    "creatives/Tools feedback V2.gif" = "C:\Users\Isuru\Special Projects\tools-lms-section\creatives\Tools feedback V2.gif"
}

Write-Host "Converting files to base64..." -ForegroundColor Cyan
$base64Map = @{}
foreach ($key in $files.Keys) {
    Write-Host "  Processing: $key" -ForegroundColor Gray
    $base64Map[$key] = Convert-FileToBase64 -FilePath $files[$key]
}

Write-Host "`nCreating base64-embedded TafeSA version..." -ForegroundColor Cyan
$tafesaHtml = Get-Content "C:\Users\Isuru\Special Projects\tools-lms-section\tools-competency-v11.html" -Raw

foreach ($key in $base64Map.Keys) {
    $tafesaHtml = $tafesaHtml.Replace('"' + $key + '"', '"' + $base64Map[$key] + '"')
}

$outputTafesa = "C:\Users\Isuru\Special Projects\tools-lms-section\tools-competency-v11-base64.html"
[System.IO.File]::WriteAllText($outputTafesa, $tafesaHtml, [System.Text.UTF8Encoding]::new($false))
Write-Host "  Created: $outputTafesa" -ForegroundColor Green

Write-Host "`nCreating base64-embedded Swinburne version..." -ForegroundColor Cyan
$swinburneHtml = Get-Content "C:\Users\Isuru\Special Projects\tools-lms-section\tools-competency-v11-swinburne.html" -Raw

foreach ($key in $base64Map.Keys) {
    $swinburneHtml = $swinburneHtml.Replace('"' + $key + '"', '"' + $base64Map[$key] + '"')
}

$outputSwinburne = "C:\Users\Isuru\Special Projects\tools-lms-section\tools-competency-v11-swinburne-base64.html"
[System.IO.File]::WriteAllText($outputSwinburne, $swinburneHtml, [System.Text.UTF8Encoding]::new($false))
Write-Host "  Created: $outputSwinburne" -ForegroundColor Green

Write-Host "`nDone! Both base64-embedded versions have been created." -ForegroundColor Green
