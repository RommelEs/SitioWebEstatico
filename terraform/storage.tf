# ============================================
# STORAGE ACCOUNT PARA SCREENSHOTS
# ============================================

resource "azurerm_storage_account" "screenshots" {
  name                       = "screenshots97428"
  resource_group_name        = azurerm_resource_group.web.name
  location                   = azurerm_resource_group.web.location
  account_tier               = "Standard"
  account_replication_type   = "LRS"
  https_traffic_only_enabled = true

  blob_properties {
    cors_rule {
      allowed_headers    = ["*"]
      allowed_methods    = ["GET", "HEAD"]
      allowed_origins    = ["*"]
      exposed_headers    = ["*"]
      max_age_in_seconds = 3600
    }
  }
}

resource "azurerm_storage_container" "screenshots" {
  name                  = "screenshots"
  storage_account_name  = azurerm_storage_account.screenshots.name
  container_access_type = "blob"
}