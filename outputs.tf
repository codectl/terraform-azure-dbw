output "workspace" {
  value = azurerm_databricks_workspace.this
}

output "access_connector" {
  value = azurerm_databricks_access_connector.this
}

output "identity" {
  value = try(
    azurerm_databricks_access_connector.this["this"].identity, null
  )
}

output "virtual_network_peerings" {
  value = azurerm_databricks_virtual_network_peering.this
}

output "workspace_root_dbfs_customer_managed_key" {
  value = try(
    azurerm_databricks_workspace_root_dbfs_customer_managed_key.this["this"], null
  )
}
