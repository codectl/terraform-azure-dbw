module "naming" {
  source  = "codectl/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dbwsf"]
}

module "regions" {
  source  = "codectl/locations/azure"
  version = "~> 1.0"

  location = {
    primary = "westeurope"
  }
}

module "rg" {
  source  = "codectl/rg/azure"
  version = "~> 1.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = module.regions.location.primary.name
    }
  }
}

module "network" {
  source  = "codectl/vnet/azure"
  version = "~> 1.0"

  vnet = {
    name                = module.naming.virtual_network.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    address_space       = ["10.40.0.0/16"]

    subnets = {
      public = {
        address_prefixes       = ["10.40.1.0/24"]
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
        address_prefixes       = ["10.40.2.0/24"]
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

module "identity" {
  source  = "codectl/uai/azure"
  version = "~> 1.0"

  identity = {
    name                = module.naming.user_assigned_identity.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "db_workspace" {
  source  = "codectl/dbw/azure"
  version = "~> 1.0"

  workspace = {
    name                        = module.naming.databricks_workspace.name_unique
    location                    = module.rg.groups.demo.location
    resource_group_name         = module.rg.groups.demo.name
    sku                         = "premium"
    managed_resource_group_name = "${module.naming.databricks_workspace.name_unique}-managed"

    default_storage_firewall_enabled = true

    enhanced_security_compliance = {
      automatic_cluster_update_enabled     = true
      enhanced_security_monitoring_enabled = true
    }

    custom_parameters = {
      virtual_network_id                                   = module.network.vnet.id
      public_subnet_name                                   = module.network.subnets.public.name
      public_subnet_network_security_group_association_id  = module.network.subnet_network_security_group_associations.public.id
      private_subnet_name                                  = module.network.subnets.private.name
      private_subnet_network_security_group_association_id = module.network.subnet_network_security_group_associations.private.id
    }
  }

  access_connector = {
    name                = "${module.naming.databricks_workspace.name}-ac"
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name

    identity = {
      type         = "UserAssigned"
      identity_ids = [module.identity.identity.id]
    }
  }
}
