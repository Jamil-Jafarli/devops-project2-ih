variable "sonarqube_vm_password" {
  description = "Sonarqube VM administrator password"
  type        = string
  sensitive   = true
}
variable "db_password" {
  description = "SQL Server administrator password"
  type        = string
  sensitive   = true
}

variable "vm_password" {
  description = "VM administrator password"
  type        = string
  sensitive   = true
}
