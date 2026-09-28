resource "azurerm_databricks_workspace" "this" {
  resource_group_name = coalesce(
    var.workspace.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.workspace.location, var.location
  )

  name                                                = var.workspace.name
  managed_resource_group_name                         = var.workspace.managed_resource_group_name
  sku                                                 = var.workspace.sku
  load_balancer_backend_address_pool_id               = var.workspace.load_balancer_backend_address_pool_id
  public_network_access_enabled                       = var.workspace.public_network_access_enabled
  network_security_group_rules_required               = var.workspace.public_network_access_enabled ? null : var.workspace.network_security_group_rules_required
  default_storage_firewall_enabled                    = var.workspace.default_storage_firewall_enabled ? true : null
  access_connector_id                                 = var.workspace.default_storage_firewall_enabled ? azurerm_databricks_access_connector.this["this"].id : null
  customer_managed_key_enabled                        = var.workspace.customer_managed_key_enabled
  infrastructure_encryption_enabled                   = var.workspace.infrastructure_encryption_enabled
  managed_services_cmk_key_vault_key_id               = var.workspace.managed_services_cmk_key_vault_key_id
  managed_disk_cmk_key_vault_key_id                   = var.workspace.managed_disk_cmk_key_vault_key_id
  managed_disk_cmk_rotation_to_latest_version_enabled = var.workspace.managed_disk_cmk_rotation_to_latest_version_enabled

  dynamic "custom_parameters" {
    for_each = var.workspace.custom_parameters != null ? { "this" = var.workspace.custom_parameters } : {}

    content {
      machine_learning_workspace_id = custom_parameters.value.machine_learning_workspace_id
      nat_gateway_name              = custom_parameters.value.nat_gateway_name
      public_ip_name                = custom_parameters.value.public_ip_name
      no_public_ip                  = custom_parameters.value.no_public_ip
      virtual_network_id            = custom_parameters.value.virtual_network_id
      vnet_address_prefix           = custom_parameters.value.vnet_address_prefix
      storage_account_name          = custom_parameters.value.storage_account_name
      storage_account_sku_name      = custom_parameters.value.storage_account_sku_name

      public_subnet_name                                   = custom_parameters.value.virtual_network_id != null ? custom_parameters.value.public_subnet_name : null
      public_subnet_network_security_group_association_id  = custom_parameters.value.virtual_network_id != null ? custom_parameters.value.public_subnet_network_security_group_association_id : null
      private_subnet_name                                  = custom_parameters.value.virtual_network_id != null ? custom_parameters.value.private_subnet_name : null
      private_subnet_network_security_group_association_id = custom_parameters.value.virtual_network_id != null ? custom_parameters.value.private_subnet_network_security_group_association_id : null
    }
  }

  dynamic "enhanced_security_compliance" {
    for_each = var.workspace.enhanced_security_compliance != null ? { "this" = var.workspace.enhanced_security_compliance } : {}

    content {
      automatic_cluster_update_enabled      = enhanced_security_compliance.value.automatic_cluster_update_enabled
      compliance_security_profile_enabled   = enhanced_security_compliance.value.compliance_security_profile_enabled
      compliance_security_profile_standards = enhanced_security_compliance.value.compliance_security_profile_standards
      enhanced_security_monitoring_enabled  = enhanced_security_compliance.value.enhanced_security_monitoring_enabled
    }
  }

  tags = coalesce(
    var.workspace.tags, var.tags
  )

  lifecycle {
    ignore_changes = [
      custom_parameters[0].nat_gateway_name,
      custom_parameters[0].public_ip_name,
      custom_parameters[0].vnet_address_prefix,
    ]
  }
}

resource "azurerm_databricks_access_connector" "this" {
  for_each = var.access_connector != null ? { "this" = var.access_connector } : {}

  name = each.value.name

  resource_group_name = coalesce(
    each.value.resource_group_name, var.resource_group_name
  )
  location = coalesce(
    each.value.location, var.location
  )

  dynamic "identity" {
    for_each = each.value.identity != null ? { "this" = each.value.identity } : {}

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  tags = coalesce(
    each.value.tags, var.tags
  )
}

resource "azurerm_databricks_virtual_network_peering" "this" {
  for_each = var.virtual_network_peerings

  name = coalesce(
    each.value.name, each.key
  )

  resource_group_name = coalesce(
    each.value.resource_group_name,
    var.workspace.resource_group_name,
    var.resource_group_name
  )
  workspace_id                  = azurerm_databricks_workspace.this.id
  remote_address_space_prefixes = each.value.remote_address_space_prefixes
  remote_virtual_network_id     = each.value.remote_virtual_network_id
  allow_virtual_network_access  = each.value.allow_virtual_network_access
  allow_forwarded_traffic       = each.value.allow_forwarded_traffic
  allow_gateway_transit         = each.value.allow_gateway_transit
  use_remote_gateways           = each.value.use_remote_gateways
}

resource "azurerm_databricks_workspace_root_dbfs_customer_managed_key" "this" {
  for_each = var.workspace_root_dbfs_customer_managed_key != null ? { "this" = var.workspace_root_dbfs_customer_managed_key } : {}

  workspace_id     = azurerm_databricks_workspace.this.id
  key_vault_key_id = each.value.key_vault_key_id
}
