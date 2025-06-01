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
