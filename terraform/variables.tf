variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "RommelEs/SitioWebEstatico"
}

# Nuevas variables para screenshots (opcionales)
variable "screenshots_container_name" {
  description = "Nombre del container para screenshots"
  type        = string
  default     = "screenshots"
}

variable "enable_screenshots_storage" {
  description = "Habilitar storage para screenshots"
  type        = bool
  default     = true
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "West Europe"
}

variable "tags" {
  description = "Tags para los recursos"
  type        = map(string)
  default = {
    Environment = "Production"
    Project     = "SitioWebEstatico"
    ManagedBy   = "Terraform"
  }
}