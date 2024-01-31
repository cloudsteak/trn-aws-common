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
Remove-Item easyrsa-Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory easyrsa

Move-Item $dir\EasyRSA-$version\* -Destination easyrsa -Force 

# Cleaning up target dir
Remove-Item $name -Recurse -Force -ErrorAction SilentlyContinue 

# Removing temp files
Remove-Item $zip -Force
Remove-Item $dir -Recurse -Force

Write-Host ####### Cert folyamat ####### -ForegroundColor Green


$desktopPath = [System.Environment]::GetFolderPath('Desktop')

$certDir = Read-Host -Prompt 'Add meg a mappa nevét'

$folder = (Join-Path -Path $desktopPath -ChildPath $certDir)
New-Item -ItemType Directory -Path $folder

# Set working directory
Set-Location -Path easyrsa

# Start easyrsa shell
Start-Process .\EasyRSA-Start.bat -Wait -NoNewWindow

echo -e "./easyrsa init-pki"
./easyrsa init-pki

echo -e "./easyrsa build-ca nopass"
./easyrsa build-ca nopass

echo -e "./easyrsa build-server-full server nopass"
./easyrsa build-server-full server nopass

echo -e "./easyrsa build-client-full client1.domain.tld nopass"
./easyrsa build-client-full client1.domain.tld nopass

exit

Write-Host "Másolás:  pki/ca.crt $folder/"
cp pki/ca.crt $folder/

Write-Host "Másolás:  pki/issued/server.crt $folder/"
cp pki/issued/server.crt $folder/

Write-Host "Másolás:  pki/private/server.key $folder/"
cp pki/private/server.key $folder/

Write-Host "Másolás:  pki/issued/client1.domain.tld.crt $folder/"
cp pki/issued/client1.domain.tld.crt $folder/

Write-Host "Másolás:  pki/private/client1.domain.tld.key $folder/"
cp pki/private/client1.domain.tld.key $folder/

Write-Host  "cd $folder/"
Set-Location -Path $folder
Invoke-Item .






