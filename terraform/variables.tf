variable "client_id" {
  description = "Client ID del Service Principal"
  type        = string
}

variable "client_secret" {
  description = "Client Secret del Service Principal"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Tenant ID de Azure"
  type        = string
}

variable "subscription_id" {
  description = "Subscription ID de Azure"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository in format 'owner/repo-name'"
  type        = string
  default     = "RommelEs/SitioWebEstatico"
}

variable "app_client_id" {
  description = "Client ID de la aplicación para autenticación OIDC"
  type        = string
}