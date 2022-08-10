# How to generate a certificate and configure SSL in IIS

1. Register a domain
2. In DNS, add record to VM IP
3. Install Certbot in VM (https://dl.eff.org/certbot-beta-installer-win32.exe)
4. Run certboot in mode webroot to generate the certificate
``certbot certonly --webroot``
5. Install openssl (needed to convert pem certificate to pfx)
6. Export certificate from pem to pfx
``openssl pkcs12 -export -out cert.pfx -inkey privatekey.pem -in cert.pem´´
7. Install pfx on SO
- Console Root
  - Win+R type mmc
  - In File menu, click on Add/Remove Snap-in...
  - Select Certificates and click on Add
  - Select Computer account and click on Next
  - In next window, click on Finish
  - Click on Ok
  - In 'Certificates', right click on Personal > All Tasks > Import
  - In 'Store Location', click on Next
  - In 'File to Import', browse to cert.pfx
  - Next > Next > Next > Finish
- IIS
  - In site, click on Bindings (in Edit Site)
  - Click on Add
  - Select https in Type, write the site name in Host name textbox and selec added certificate in SSL certificate . Click ok
8. Browser your site in https
