terraform {
  //Actualización reciente
  backend "azurerm" {
    resource_group_name  = "rg-terraform-backend"
    storage_account_name = "tfbackend1748962482"  # Reemplazar con el nombre que te mostró el script
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
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

// Actualización reciente
# CDN Profile
resource "azurerm_cdn_profile" "web" {
  name                = "cdn-sitioweb-${random_integer.rand.result}"
  location            = azurerm_resource_group.web.location
  resource_group_name = azurerm_resource_group.web.name
  sku                 = "Standard_Microsoft"

  tags = {
    environment = "production"
    project     = "static-website"
  }
}

# CDN Endpoint
resource "azurerm_cdn_endpoint" "web" {
  name                = "endpoint-sitioweb-${random_integer.rand.result}"
  profile_name        = azurerm_cdn_profile.web.name
  location            = azurerm_resource_group.web.location
  resource_group_name = azurerm_resource_group.web.name

  origin_host_header = azurerm_storage_account.web.primary_web_host

  origin {
    name      = "primary"
    host_name = azurerm_storage_account.web.primary_web_host
  }

  # Configuración de caché para archivos estáticos
  delivery_rule {
    name  = "CacheStaticAssets"
    order = 1

    url_file_extension_condition {
      operator         = "Equal"
      match_values     = ["css", "js", "png", "jpg", "jpeg", "gif", "svg", "ico"]
      negate_condition = false
    }

    cache_expiration_action {
      behavior = "Override"
      duration = "1.00:00:00" # 1 día
    }
  }

  # Regla para HTML con caché más corto
  delivery_rule {
    name  = "CacheHTMLFiles"
    order = 2

    url_file_extension_condition {
      operator         = "Equal"
      match_values     = ["html"]
      negate_condition = false
    }

    cache_expiration_action {
      behavior = "Override"
      duration = "01:00:00" # 1 hora
    }
  }

  # Compresión GZIP
  is_compression_enabled = true
  content_types_to_compress = [
    "application/javascript",
    "application/json",
    "text/css",
    "text/html",
    "text/javascript",
    "text/plain"
  ]

  tags = {
    environment = "production"
    project     = "static-website"
  }
}