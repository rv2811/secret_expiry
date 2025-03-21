# data "archive_file" "function_zip" {
#   type        = "zip"
#   source_dir  = "../test.ps1"
#   output_path = "../function.zip"
# }

resource "azurerm_service_plan" "asp" {
  name = "secret-function-asp"
  location = var.rglocation
  resource_group_name = var.rgname
  os_type = "Linux"
  sku_name = "B1"
 
}

resource "azurerm_linux_function_app" "functions-app" {
  name = "secret-expiry-notify"
  location = var.rglocation
  storage_account_access_key = var.function_storage_key
  storage_account_name = var.function_storage_name
  resource_group_name = var.rgname
  service_plan_id = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      powershell_core_version = "7.2"
    }

  }
}



resource "azurerm_function_app_function" "function" {
  name = "TimerTriggerPowershell"
  function_app_id = azurerm_linux_function_app.functions-app.id
  language = "PowerShell"
#   file_system_publish {
#     package {
#         package_path = "./function.zip"
#     }
#   }
    file {
    name    = "secretexpiry.ps1"
    content = file("./secretexpiry.ps1")
  }
  config_json = jsonencode({
    "bindings" = [
      {
        "name" = "Timer",
        "type" = "timerTrigger",
        "direction" = "in",
        "schedule" = "0 */5 * * * *" # Runs every 5 minutes
      }
    ]
  })
}

