resource "azurerm_storage_account" "storage" {
  name = "functionsappstr111"
  resource_group_name = var.rgname
  location = var.rglocation
  account_tier = "Standard"
  account_replication_type = "LRS"
} 