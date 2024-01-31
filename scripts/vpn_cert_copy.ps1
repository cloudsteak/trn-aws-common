
#PowerShell

Write-Host ####### Cert folyamat ####### -ForegroundColor Green


$desktopPath = [System.Environment]::GetFolderPath('Desktop')

$certDir = Read-Host -Prompt 'Add meg a mappa nevét'

$folder = (Join-Path -Path $desktopPath -ChildPath $certDir)
New-Item -ItemType Directory -Path $folder

Write-Host "Mozgat: pki/ca.crt $folder/"
cp pki/ca.crt $folder/

Write-Host "Mozgat: pki/issued/server.crt $folder/"
cp pki/issued/server.crt $folder/

Write-Host "Mozgat: pki/private/server.key $folder/"
cp pki/private/server.key $folder/

Write-Host "Mozgat: pki/issued/client1.domain.tld.crt $folder/"
cp pki/issued/client1.domain.tld.crt $folder/

Write-Host "Mozgat: pki/private/client1.domain.tld.key $folder/"
cp pki/private/client1.domain.tld.key $folder/

Write-Host  "cd $folder/"
Set-Location -Path $folder
Invoke-Item .






