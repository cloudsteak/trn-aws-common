#PowerShell

Write-Host "####### Easy RSA #######" -ForegroundColor Green

$repo = "OpenVPN/easy-rsa"
  
$releases = "https://api.github.com/repos/$repo/releases"
  
Write-Host Keres: Friss csomag
$tag = (Invoke-WebRequest $releases | ConvertFrom-Json)[0].tag_name
  
$version = $tag.Replace("v", "")
$file = "EasyRSA-$version-win64.zip"
$download = "https://github.com/$repo/releases/download/$tag/$file"
$name = $file.Split(".")[0]
$zip = "$name-$tag.zip"
$dir = "$name-$tag"
  
Write-Host Beszerez: Friss csomag ($tag)
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
  
Write-Host "####### Mappa: easyrsa #######" -ForegroundColor Green
  
# Set working directory
Set-Location -Path easyrsa
   
  