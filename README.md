# Databricks workspace

This terraform module simplifies the process of creating and managing a databricks workspace on azure with customizable options and features, offering a flexible and powerful solution for managing azure databricks workspace through code.

## Features

- offers support for private and public databricks workspace
- utilization of terratest for robust validation.
- supports optional custom parameters for vnet injection (bring your own VNET).
- supports optional custom parameters for dbfs storage account name and sku.
- integrates with databricks access connector identity configuration in case default storage firewall is set to enabled
- supports optional databricks virtual network peering resources
- supports optional root dbfs customer managed key configuration

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 5.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 5.0)

## Resources

The following resources are used by this module:

- [azurerm_databricks_access_connector.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_access_connector) (resource)
- [azurerm_databricks_virtual_network_peering.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_virtual_network_peering) (resource)
- [azurerm_databricks_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace) (resource)
- [azurerm_databricks_workspace_root_dbfs_customer_managed_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace_root_dbfs_customer_managed_key) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_workspace"></a> [workspace](#input\_workspace)

Description: databricks workspace configuration

Type:

```hcl
object({
    name                                                = string
    resource_group_name                                 = optional(string)
    location                                            = optional(string)
    managed_resource_group_name                         = optional(string)
    sku                                                 = string
    load_balancer_backend_address_pool_id               = optional(string)
    public_network_access_enabled                       = optional(bool, true)
    network_security_group_rules_required               = optional(string)
    default_storage_firewall_enabled                    = optional(bool, false)
    customer_managed_key_enabled                        = optional(bool)
    infrastructure_encryption_enabled                   = optional(bool)
    managed_services_cmk_key_vault_key_id               = optional(string)
    managed_disk_cmk_key_vault_key_id                   = optional(string)
    managed_disk_cmk_rotation_to_latest_version_enabled = optional(bool)
    custom_parameters = optional(object({
      machine_learning_workspace_id                        = optional(string)
      nat_gateway_name                                     = optional(string)
      public_ip_name                                       = optional(string)
      no_public_ip                                         = optional(bool)
      virtual_network_id                                   = optional(string)
      public_subnet_name                                   = optional(string)
      public_subnet_network_security_group_association_id  = optional(string)
      private_subnet_name                                  = optional(string)
      private_subnet_network_security_group_association_id = optional(string)
      vnet_address_prefix                                  = optional(string)
      storage_account_name                                 = optional(string)
      storage_account_sku_name                             = optional(string)
    }))
    enhanced_security_compliance = optional(object({
      automatic_cluster_update_enabled      = optional(bool)
      compliance_security_profile_enabled   = optional(bool)
      compliance_security_profile_standards = optional(list(string), [])
      enhanced_security_monitoring_enabled  = optional(bool)
    }))
    tags = optional(map(string))
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_access_connector"></a> [access\_connector](#input\_access\_connector)

Description: databricks access connector configuration

Type:

```hcl
object({
    name                = string
    resource_group_name = optional(string)
    location            = optional(string)
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    tags = optional(map(string))
  })
```

Default: `null`

### <a name="input_location"></a> [location](#input\_location)

Description: default azure region to be used.

Type: `string`

Default: `null`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: default resource group name to be used.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: tags to be added to the resources

Type: `map(string)`

Default: `{}`

### <a name="input_virtual_network_peerings"></a> [virtual\_network\_peerings](#input\_virtual\_network\_peerings)

Description: databricks virtual network peering configuration

Type:

```hcl
map(object({
    name                          = optional(string)
    resource_group_name           = optional(string)
    remote_address_space_prefixes = list(string)
    remote_virtual_network_id     = string
    allow_virtual_network_access  = optional(bool)
    allow_forwarded_traffic       = optional(bool)
    allow_gateway_transit         = optional(bool)
    use_remote_gateways           = optional(bool)
  }))
```

Default: `{}`

### <a name="input_workspace_root_dbfs_customer_managed_key"></a> [workspace\_root\_dbfs\_customer\_managed\_key](#input\_workspace\_root\_dbfs\_customer\_managed\_key)

Description: root dbfs customer managed key configuration

Type:

```hcl
object({
    key_vault_key_id = string
  })
```

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_access_connector"></a> [access\_connector](#output\_access\_connector)

Description: n/a

### <a name="output_identity"></a> [identity](#output\_identity)

Description: n/a

### <a name="output_virtual_network_peerings"></a> [virtual\_network\_peerings](#output\_virtual\_network\_peerings)

Description: n/a

### <a name="output_workspace"></a> [workspace](#output\_workspace)

Description: n/a

### <a name="output_workspace_root_dbfs_customer_managed_key"></a> [workspace\_root\_dbfs\_customer\_managed\_key](#output\_workspace\_root\_dbfs\_customer\_managed\_key)

Description: n/a
<!-- END_TF_DOCS -->

## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md).

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/databricks)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/databricks)
