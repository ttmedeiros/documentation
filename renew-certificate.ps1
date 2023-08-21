# Parameters
$siteUrl = "ccftl.meijunlabs.com"
$siteCertName = "root-cert"
$siteName = "ccftl"
$pfxFilePath = ".\cert.pfx"
$pfxPassword = "12345678"

echo '---- Starting root-cert website ----'
Start-Website $siteCertName

echo '---- Renew Certificate ----'
certbot renew --cert-name $siteUrl

echo '---- Generate PFX ----'
openssl pkcs12 -password pass:$pfxPassword -export -out $pfxFilePath -inkey privkey.pem -in cert.pem

echo '---- Stoping root-cert website ----'
Stop-Website $siteCertName

$command = "netsh http delete sslcert scopedccs=$siteUrl:443"
Write-Host "Running command: $command"
Invoke-Expression $command

# Import the .pfx certificate
Write-Host "Importing the certificate..."
$cert = Import-PfxCertificate -FilePath $pfxFilePath -CertStoreLocation Cert:\LocalMachine\My -Password (ConvertTo-SecureString -String $pfxPassword -Force -AsPlainText)

$command = "netsh http add sslcert scopedccs=$siteUrl:443"
Write-Host "Running command: $command"
Invoke-Expression $command

# Restart the site (Application Pool)
Write-Host "Restarting the $siteName site..."
Restart-WebAppPool -Name "${siteName}"
Write-Host "$siteName site has been restarted."
