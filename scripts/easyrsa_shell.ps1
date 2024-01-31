 #PowerShell

 Write-Host ####### Easy RSA ####### -ForegroundColor Green

$repo = "OpenVPN/easy-rsa"
$file = "EasyRSA-3.1.7-win64.zip"

$releases = "https://api.github.com/repos/$repo/releases"

Write-Host Friss csomag - keres
$tag = (Invoke-WebRequest $releases | ConvertFrom-Json)[0].tag_name

$download = "https://github.com/$repo/releases/download/$tag/$file"
$name = $file.Split(".")[0]
$zip = "$name-$tag.zip"
$dir = "$name-$tag"
$version = $tag.Replace("v", "")

Write-Host Friss csomag - beszerez
Invoke-WebRequest $download -Out $zip

Write-Host Unzip
Expand-Archive $zip -Force


Write-Host easyrsa mappa
Remove-Item easyrsa -Recurse -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
New-Item -ItemType Directory easyrsa -ErrorAction SilentlyContinue

Move-Item $dir\EasyRSA-$version\* -Destination easyrsa -Force 

# Removing temp files
Remove-Item $zip -Force
Remove-Item $dir -Recurse -Force

Write-Host ####### Start Shell ####### -ForegroundColor Green

# Set working directory
Set-Location -Path easyrsa

# Start easyrsa shell
Start-Process .\EasyRSA-Start.bat -Wait
