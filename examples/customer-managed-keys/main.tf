module "naming" {
  source  = "codectl/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dbwcmk"]
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

data "azuread_service_principal" "databricks" {
  client_id = "2ff814a6-3304-4ab8-85cb-cd0e6f879c1d"
}

module "kv" {
  source  = "codectl/kv/azure"
  version = "~> 1.0"

  vault = {
    name                = module.naming.key_vault.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    sku_name            = "premium"

    purge_protection_enabled   = true
    soft_delete_retention_days = 7

    keys = {
      services = {
        key_type = "RSA"
        key_size = 2048

        key_opts = [
          "decrypt", "encrypt",
          "sign", "unwrapKey",
          "verify", "wrapKey"
        ]
      }
    }
  }
}

module "rbac" {
  source  = "codectl/rbac/azure"
  version = "~> 1.0"

  role_assignments = {
    databricks = {
      type      = "ServicePrincipal"
      object_id = data.azuread_service_principal.databricks.object_id

      roles = {
        "Key Vault Crypto Service Encryption User" = {
          scopes = {
            vault = {
              id = module.kv.vault.id
            }
          }
        }
      }
    }
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

    managed_services_cmk_key_vault_key_id = module.kv.keys.services.id
  }

  depends_on = [module.rbac]
}
