output "static_website_url" {
  description = "URL pública del sitio web estático en Azure Storage"
  value       = azurerm_storage_account.web.primary_web_endpoint
}

output "client_id" {
  description = "Application Client ID para autenticación OIDC"
  value       = azuread_application.web_auth.client_id
}

output "tenant_id" {
  description = "Tenant ID de Azure AD"
  value       = var.tenant_id
}