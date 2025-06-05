# Outputs existentes del sitio web
output "website_url" {
  description = "URL del sitio web estático"
  value       = azurerm_storage_account.web.primary_web_endpoint
}

output "website_storage_account_name" {
  description = "Nombre del Storage Account del sitio web"
  value       = azurerm_storage_account.web.name
}

output "resource_group_name" {
  description = "Nombre del Resource Group"
  value       = azurerm_resource_group.web.name
}

# Eliminar este output:
# output "random_suffix" {
#   description = "Sufijo aleatorio usado"
#   value       = random_integer.rand.result
# }

# Nuevos outputs para screenshots
output "screenshots_storage_account_name" {
  description = "Nombre del Storage Account para screenshots"
  value       = azurerm_storage_account.screenshots.name
}

output "screenshots_blob_url" {
  description = "URL base para acceder a las screenshots"
  value       = "https://${azurerm_storage_account.screenshots.name}.blob.core.windows.net/screenshots"
}

output "screenshots_storage_account_primary_access_key" {
  description = "Clave del Storage Account para screenshots"
  value       = azurerm_storage_account.screenshots.primary_access_key
  sensitive   = true
}