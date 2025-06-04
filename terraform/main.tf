terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-backend"
    storage_account_name = "tfbackend1749044298"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
  
  # Configuración explícita para CI/CD
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  
  # Deshabilitar Azure CLI para CI/CD
  use_cli = false
}

provider "azuread" {
  client_id     = var.client_id
  client_secret = var.client_secret
  tenant_id     = var.tenant_id
}

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "web" {
  name     = "rg-sitioweb-${random_integer.rand.result}"
  location = "West Europe"
}

# App Registration para OIDC
resource "azuread_application" "web_auth" {
  display_name = "SitioWebEstatico-Auth-${random_integer.rand.result}"
  
  single_page_application {
    redirect_uris = [
      "http://localhost:3000",
      "https://sitioweb${random_integer.rand.result}.z6.web.core.windows.net/"
    ]
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph
    
    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }
}

# Service Principal para la aplicación
resource "azuread_service_principal" "web_auth" {
  client_id = azuread_application.web_auth.client_id
}

# Federated credential para GitHub Actions
resource "azuread_application_federated_identity_credential" "github" {
  application_id = azuread_application.web_auth.id
  display_name   = "github-actions-main"
  description    = "GitHub Actions credential for main branch"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_repo}:ref:refs/heads/main"
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
    client_id = azuread_application.web_auth.client_id
    tenant_id = var.tenant_id
    redirect_uri = "${azurerm_storage_account.web.primary_web_endpoint}/"
  })
}