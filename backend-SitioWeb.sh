# Variables con nombre único
RESOURCE_GROUP_NAME="rg-terraform-backend"
STORAGE_ACCOUNT_NAME="tfbackend$(date +%s)"  # Genera número único basado en timestamp
CONTAINER_NAME="tfstate"
LOCATION="West Europe"

echo "🚀 Creando backend de Terraform..."
echo "Storage Account: $STORAGE_ACCOUNT_NAME"

# Crear Resource Group
az group create --name $RESOURCE_GROUP_NAME --location "$LOCATION"

# Crear Storage Account
az storage account create \
  --resource-group $RESOURCE_GROUP_NAME \
  --name $STORAGE_ACCOUNT_NAME \
  --sku Standard_LRS \
  --location "$LOCATION"

# Crear Container
az storage container create \
  --name $CONTAINER_NAME \
  --account-name $STORAGE_ACCOUNT_NAME

echo ""
echo "✅ Backend creado exitosamente!"
echo "📝 Storage Account name: $STORAGE_ACCOUNT_NAME"
echo "📝 Usa este nombre en tu main.tf"