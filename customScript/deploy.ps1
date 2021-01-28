# install IIS & télécharge le contenu

Install-WindowsFeature Web-Server,Web-Asp-Net45

cd c:/inetpub/wwwroot
rm -Recurse *

mkdir c:/tmp
cd c:/tmp

# Monter le niveau TLS de cette session PS (nécessaire pour win2016 mais pas 2019)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Invoke-WebRequest https://raw.githubusercontent.com/jcd717/azure-vmss/master/AppliWeb.zip -OutFile AppliWeb.zip
Expand-Archive -LiteralPath ./AppliWeb.zip -DestinationPath .
cp -Recurse .\AppliWeb\* C:\inetpub\wwwroot

cd /
rm -Recurse tmp

echo "version 2" > c:/inetpub/wwwroot/page.html


