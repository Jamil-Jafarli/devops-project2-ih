# Variables for Burger Builder Infrastructure

variable "tf_state_rg" {
  description = "Resource group for remote state storage"
  type        = string
}

variable "tf_state_storage" {
  description = "Storage account for remote state"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "vm_password" {
  description = "VM password"
  type        = string
  sensitive   = true
}
