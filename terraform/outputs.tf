output "static_website_url" {
  description = "URL pública del sitio web estático en Azure Storage"
  value       = azurerm_storage_account.web.primary_web_endpoint
}

output "client_id" {
  description = "Application Client ID para autenticación OIDC"
  value       = var.app_client_id  # Cambiado para usar la variable en lugar del recurso comentado
}

output "tenant_id" {
  description = "Tenant ID de Azure AD"
  value       = var.tenant_id
}