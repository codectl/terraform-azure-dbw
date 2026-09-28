moved {
  from = azurerm_databricks_access_connector.this["default"]
  to   = azurerm_databricks_access_connector.this["this"]
}

moved {
  from = azurerm_databricks_workspace_root_dbfs_customer_managed_key.this["default"]
  to   = azurerm_databricks_workspace_root_dbfs_customer_managed_key.this["this"]
}
