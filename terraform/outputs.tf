output "static_website_url" {
  description = "URL pública del sitio web estático en Azure Storage"
  value       = azurerm_storage_account.web.primary_web_endpoint
}

// Actualización reciente
output "cdn_endpoint_url" {
  description = "URL del endpoint CDN"
  value       = "https://${azurerm_cdn_endpoint.web.fqdn}"
}

output "cdn_profile_name" {
  description = "Nombre del perfil CDN"
  value       = azurerm_cdn_profile.web.name
}

output "cdn_endpoint_name" {
  description = "Nombre del endpoint CDN"
  value       = azurerm_cdn_endpoint.web.name
}

output "resource_group_name" {
  description = "Nombre del grupo de recursos"
  value       = azurerm_resource_group.web.name
}