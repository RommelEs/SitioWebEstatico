terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-backend"
    storage_account_name = "tfbackend1749044298"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    
    # Comentar temporalmente para desarrollo local
    # use_cli = false
  }
}

provider "azurerm" {
  features {}
  
  # Comentar temporalmente para desarrollo local
  # use_cli = false
}

provider "azuread" {
  # Comentar temporalmente para desarrollo local
  # use_cli = false
}

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "web" {
  name     = "rg-sitioweb-${random_integer.rand.result}"
  location = "West Europe"
}

resource "azurerm_storage_account" "web" {
  name                     = "sitioweb${random_integer.rand.result}"
  resource_group_name      = azurerm_resource_group.web.name
  location                 = azurerm_resource_group.web.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  https_traffic_only_enabled = true
  
  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
}

resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.web.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "../website/index.html"
  content_type           = "text/html"
}

resource "azurerm_storage_blob" "error" {
  name                   = "404.html"
  storage_account_name   = azurerm_storage_account.web.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "${path.module}/../website/404.html"
  content_type           = "text/html"
}

resource "azurerm_storage_blob" "style" {
  name                   = "style.css"
  storage_account_name   = azurerm_storage_account.web.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "${path.module}/../website/style.css"
  content_type           = "text/css"
}

# Agregar archivo de configuración de autenticación
resource "azurerm_storage_blob" "auth_config" {
  name                   = "auth-config.js"
  storage_account_name   = azurerm_storage_account.web.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "application/javascript"
  
  source_content = templatefile("${path.module}/../website/auth-config.js.tpl", {
    client_id = var.app_client_id
    tenant_id = var.tenant_id  # ❌ Esto también necesita ser definido como variable
    redirect_uri = "${azurerm_storage_account.web.primary_web_endpoint}"
  })
}