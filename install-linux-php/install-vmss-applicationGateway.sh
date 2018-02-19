# Create an application gateway with a virtual machine scale set using the Azure CLI

location=eastus
rgName=agVmSS


# le réseau
vnetName=agVmSS-vnet
vnetSpace="10.123.0.0/16"

vnetSubnetName=subnet1
vnetSubnet="10.123.1.0/24"

vnetSubnetNameBackEnd=subnet-backend
vnetSubnetBackEnd="10.123.2.0/24"

publicIPName=agVmSS-IP


az group create --name $rgName --location $location

az network vnet create \
  --name $vnetName \
  --resource-group $rgName \
  --location $location \
  --address-prefix $vnetSpace \
  --subnet-name $vnetSubnetName \
  --subnet-prefix $vnetSubnet

az network vnet subnet create \
  --name $vnetSubnetNameBackEnd \
  --resource-group $rgName \
  --vnet-name $vnetName \
  --address-prefix $vnetSubnetBackEnd

az network public-ip create \
  --resource-group $rgName \
  --name $publicIPName


# application gateway

agName=agVmSS-ag

az network application-gateway create \
  --name $agName \
  --location $location \
  --resource-group $rgName \
  --vnet-name $vnetName \
  --subnet $vnetSubnetName \
  --capacity 1 \
  --sku Standard_Medium \
  --http-settings-cookie-based-affinity Enabled \
  --frontend-port 80 \
  --http-settings-port 80 \
  --http-settings-protocol Http \
  --public-ip-address $publicIPName


# Create a virtual machine scale set

vmssName=vmss-ag
userName=bruno
userPassword='Pa$$w0rd1234'
vmSKU='Standard_B2S'

az vmss create \
  --name $vmssName \
  --resource-group $rgName \
  --image UbuntuLTS \
  --admin-username $userName \
  --admin-password $userPassword \
  --instance-count 2 \
  --vnet-name $vnetName \
  --subnet $vnetSubnetNameBackEnd \
  --vm-sku $vmSKU \
  --upgrade-policy-mode Automatic \
  --app-gateway $agName \
  --backend-pool-name appGatewayBackendPool


# installation & configuration dues VM du Scale Set

az vmss extension set \
  --publisher Microsoft.Azure.Extensions \
  --version 2.0 \
  --name CustomScript \
  --resource-group $rgName \
  --vmss-name $vmssName \
  --settings '{ "fileUris": ["https://raw.githubusercontent.com/jcd717/azure-vmss/master/install-linux-php/install.sh"], "commandToExecute": "./install.sh" }'

