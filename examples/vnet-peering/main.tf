module "naming" {
  source  = "codectl/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dbwvp"]
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
    address_space       = ["10.60.0.0/16"]

    subnets = {
      workloads = {
        address_prefixes = ["10.60.1.0/24"]
      }
    }
  }
}

module "db_workspace" {
  source  = "codectl/dbw/azure"
  version = "~> 1.0"

  workspace = {
    name                = module.naming.databricks_workspace.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    sku                 = "premium"
  }

  virtual_network_peerings = {
    workloads = {
      remote_virtual_network_id     = module.network.vnet.id
      remote_address_space_prefixes = module.network.vnet.address_space
      allow_forwarded_traffic       = true
    }
  }
}
