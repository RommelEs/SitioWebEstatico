variable "app_client_id" {
  description = "Application Client ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure AD Tenant ID"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "RommelEs/SitioWebEstatico"
}