terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "4.6.0"
    }
  }
  # backend "azurerm" {
  #   resource_group_name  = "rg-dev"             # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
  #   storage_account_name = "backend11"                                 # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
  #   container_name       = "tfstate"                                  # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
  #   key                  = "dev.terraform.tfstate"                   # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  #   access_key           = "abcdefghijklmnopqrstuvwxyz0123456789..."
  # }
}

provider "azurerm" {
  features {
    
  }
  subscription_id = "6e31d38d-26b2-435f-b4bd-010764a59a32"
}

# module "rg" {
#   source = "./rg"
#   env = var.env
#   rglocation = var.rglocation
# }

module "secret_expiry" {
  source = "./secret_expiry"
  kvname = var.kvname
  rgname1 = var.rgname1
  rglocation = "eastus"
  action = var.action
}
