output "static_website_url" {
  description = "URL pública del sitio web estático en Azure Storage"
  value       = azurerm_storage_account.web.primary_web_endpoint
}

output "resource_group_name" {
  description = "Nombre del grupo de recursos creado"
  value       = azurerm_resource_group.web.name
}

output "storage_account_name" {
  description = "Nombre de la cuenta de almacenamiento"
  value       = azurerm_storage_account.web.name
}