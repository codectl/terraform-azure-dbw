module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.32"

  suffix = ["demo", "vneti"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 3.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 10.0"

  vnet = {
    name                = module.naming.virtual_network.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    address_space       = ["10.20.0.0/16"]

    subnets = {
      public = {
        address_prefixes       = ["10.20.1.0/24"]
        network_security_group = {}

        delegations = {
          databricks = {
            name = "Microsoft.Databricks/workspaces"
            actions = [
              "Microsoft.Network/virtualNetworks/subnets/join/action",
              "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
              "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
            ]
          }
        }
      }

      private = {
        address_prefixes       = ["10.20.2.0/24"]
        network_security_group = {}

        delegations = {
          databricks = {
            name = "Microsoft.Databricks/workspaces"
            actions = [
              "Microsoft.Network/virtualNetworks/subnets/join/action",
              "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
              "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
            ]
          }
        }
      }
    }
  }
}

module "db_workspace" {
  source  = "cloudnationhq/dbw/azure"
  version = "~> 3.0"

  workspace = {
    name                        = module.naming.databricks_workspace.name_unique
    location                    = module.rg.groups.demo.location
    resource_group_name         = module.rg.groups.demo.name
    sku                         = "premium"
    managed_resource_group_name = "${module.naming.databricks_workspace.name_unique}-managed"

    public_network_access_enabled         = false
    network_security_group_rules_required = "NoAzureDatabricksRules"

    custom_parameters = {
      no_public_ip                                         = true
      virtual_network_id                                   = module.network.vnet.id
      public_subnet_name                                   = module.network.subnets.public.name
      public_subnet_network_security_group_association_id  = module.network.subnet_network_security_group_associations.public.id
      private_subnet_name                                  = module.network.subnets.private.name
      private_subnet_network_security_group_association_id = module.network.subnet_network_security_group_associations.private.id
    }
  }
}
