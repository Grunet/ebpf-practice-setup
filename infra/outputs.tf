output "resource_group_name" {
  value = azurerm_resource_group.example.name
}

output "vm_public_ip_address" {
  value = azurerm_public_ip.example.ip_address
}
