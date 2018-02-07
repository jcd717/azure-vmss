# installation d'un VMSS avec custom script qui déploie une appli Web

# après un Login ou un RmContext:

$resourceGroupName="vmss"
$location="southcentralus"
$skuName="Standard_B2s"
$numberOfInstances=2

$password='changeit'

New-AzureRmResourceGroup -ResourceGroupName $resourceGroupName -Location $location

# Create a config object
$vmssConfig = New-AzureRmVmssConfig `
    -Location $location `
    -SkuCapacity $numberOfInstances `
    -SkuName $skuName `
    -UpgradePolicyMode Automatic

# Define the script for your Custom Script Extension to run
$publicSettings = @{
    "fileUris" = (,"https://raw.githubusercontent.com/jcd717/azure-vmss/master/customScript/deploy.ps1");
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File deploy.ps1"
}

# Use Custom Script Extension to install IIS and configure basic website
Add-AzureRmVmssExtension -VirtualMachineScaleSet $vmssConfig `
    -Name "customScript" `
    -Publisher "Microsoft.Compute" `
    -Type "CustomScriptExtension" `
    -TypeHandlerVersion 1.8 `
    -Setting $publicSettings

# Create a load balancer that has a public IP address and distributes web traffic on port 80

# Create a public IP address
$publicIP = New-AzureRmPublicIpAddress `
  -ResourceGroupName $resourceGroupName `
  -Location $location `
  -AllocationMethod Dynamic `
  -Name ($resourceGroupName+"-IPlb")

# Create a frontend and backend IP pool
$frontendIP = New-AzureRmLoadBalancerFrontendIpConfig `
  -Name myFrontEndPool `
  -PublicIpAddress $publicIP
$backendPool = New-AzureRmLoadBalancerBackendAddressPoolConfig -Name myBackEndPool

# Create the load balancer
$lb = New-AzureRmLoadBalancer `
  -ResourceGroupName $resourceGroupName `
  -Name ($resourceGroupName+"-lb") `
  -Location $location `
  -FrontendIpConfiguration $frontendIP `
  -BackendAddressPool $backendPool

# Create a load balancer health probe on port 80
Add-AzureRmLoadBalancerProbeConfig -Name myHealthProbe `
  -LoadBalancer $lb `
  -Protocol tcp `
  -Port 80 `
  -IntervalInSeconds 15 `
  -ProbeCount 2

# Create a load balancer rule to distribute traffic on port 80
Add-AzureRmLoadBalancerRuleConfig `
  -Name ($resourceGroupName+"-LoadBalancerRule") `
  -LoadBalancer $lb `
  -FrontendIpConfiguration $lb.FrontendIpConfigurations[0] `
  -BackendAddressPool $lb.BackendAddressPools[0] `
  -Protocol Tcp `
  -FrontendPort 80 `
  -BackendPort 80

# Update the load balancer configuration
Set-AzureRmLoadBalancer -LoadBalancer $lb


# Create a scale set

# Reference a virtual machine image from the gallery
Set-AzureRmVmssStorageProfile $vmssConfig `
  -ImageReferencePublisher MicrosoftWindowsServer `
  -ImageReferenceOffer WindowsServer `
  -ImageReferenceSku 2016-Datacenter `
  -ImageReferenceVersion latest

# Set up information for authenticating with the virtual machine
Set-AzureRmVmssOsProfile $vmssConfig `
  -AdminUsername "bruno" `
  -AdminPassword $password `
  -ComputerNamePrefix "jcd-vm"

# Create the virtual network resources
$subnet = New-AzureRmVirtualNetworkSubnetConfig `
  -Name "subnet1" `
  -AddressPrefix 10.200.1.0/24
$vnet = New-AzureRmVirtualNetwork `
  -ResourceGroupName $resourceGroupName `
  -Name ($resourceGroupName+"-vnet") `
  -Location $location `
  -AddressPrefix 10.200.0.0/16 `
  -Subnet $subnet
$ipConfig = New-AzureRmVmssIpConfig `
  -Name "myIPConfig" `
  -LoadBalancerBackendAddressPoolsId $lb.BackendAddressPools[0].Id `
  -SubnetId $vnet.Subnets[0].Id

# Attach the virtual network to the config object
Add-AzureRmVmssNetworkInterfaceConfiguration `
  -VirtualMachineScaleSet $vmssConfig `
  -Name "network-config" `
  -Primary $true `
  -IPConfiguration $ipConfig

# Create the scale set with the config object (this step might take a few minutes)
New-AzureRmVmss `
  -ResourceGroupName $resourceGroupName `
  -Name ("jcd-"+$resourceGroupName) `
  -VirtualMachineScaleSet $vmssConfig
