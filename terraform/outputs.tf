output "sonarqube_vm_private_ip" {
  description = "Private IP of the Sonarqube VM"
  value       = azurerm_network_interface.sonarqube.private_ip_address
}
output "app_gateway_public_ip" {
  description = "Public IP of the Application Gateway"
  value       = azurerm_public_ip.agw.ip_address
}

output "vm_private_ip" {
  description = "Static private IP of the VM"
  value       = azurerm_network_interface.vm.private_ip_address
}

output "db_fqdn" {
  description = "FQDN of the SQL Server"
  value       = azurerm_mssql_server.main.fully_qualified_domain_name
}

output "vm_ssh_private_key" {
  description = "SSH private key – never commit to source control"
  value       = tls_private_key.vm_ssh.private_key_pem
  sensitive   = true
}

output "vm_password" {
  description = "VM admin password"
  value       = var.vm_password
  sensitive   = true
}
