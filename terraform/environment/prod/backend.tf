# terraform {
#   backend "azurerm" {
#     resource_group_name  = "terraform-backend-function"
#     storage_account_name = "terraformbackend"
#     container_name       = "tfstate"
#     key                  = "prod.terraform.tfstate"
#   }
# }