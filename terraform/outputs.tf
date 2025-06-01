output "static_website_url" {
  description = "URL pública del sitio web estático en Azure Storage"
  value       = azurerm_storage_account.web.primary_web_endpoint
}