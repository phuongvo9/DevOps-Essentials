az login

az account subscription list

# Create a Resource group

location='WestUS'
az group create \
  --name {name of your resource group} \
  --location "$location"


 
$templateFile = "azuredeploy.json"
$today=Get-Date -Format "MM-dd-yyyy"
$deploymentName="blanktemplate-"+"$today"
# New-AzResourceGroupDeployment
#   -Name $deploymentName `
#   -TemplateFile $templateFile

my_resource_group='learn-bd92f45e-7000-4712-b9be-1ae12bd1ed9c'
#deploymentName='blanktemplate-19032022'
deploymentName='addstorage1903_2'
templateFile='azuredeploy.json'
# To deploy to a resource group

az deployment group create \
  --name $deploymentName \
  --resource-group $my_resource_group \
  --template-file $templateFile \
 # --parameters storageAccountType=Standard_GRS