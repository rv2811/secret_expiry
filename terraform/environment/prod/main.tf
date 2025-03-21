module "rg" {
  source = "../../modules/rg"
  rgname = var.rgname
  rglocation = var.rglocation
}

module "function-storage" {
  source = "../../modules/storage"
  rgname = module.rg.rgname
  rglocation = module.rg.rglocation
}
module "function" {
  source = "../../modules/secret_mgmt_function"
  rgname = module.rg.rgname
  rglocation = module.rg.rglocation
  function_storage_name = module.function-storage.function_storage_name
  function_storage_key = module.function-storage.function_storage_key
}