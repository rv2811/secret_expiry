data "azurerm_key_vault" "kv" {
  name = var.kvname
  resource_group_name = var.rgname1
}

resource "azurerm_monitor_action_group" "ag" {
  name = var.action
  resource_group_name = var.rgname1 
  short_name = "Mail"

  email_receiver {
    name = "secret_expiry"
    email_address = "ravi.suthar@expresspros.com"
    use_common_alert_schema = true
  }
}
# resource "azurerm_log_analytics_workspace" "log-ws" {
#   name = "log-secret-expiry-workspace"
#   location = var.rglocation
#   resource_group_name = var.rgname1
# }

# resource "azurerm_monitor_diagnostic_setting" "logs" {
#   name = "diagnostics"
#   target_resource_id = data.azurerm_key_vault.kv.id
#   partner_solution_id = azurerm_log_analytics_workspace.log-ws.id

#   enabled_log {
#     category = "AuditEvent"
#   }
#   metric {
#     category = "AllMetrics"
#   }
# }
resource "azurerm_monitor_scheduled_query_rules_alert" "alert" {
  name = "secret-expiry"
  location = var.rglocation
  resource_group_name = var.rgname1

  authorized_resource_ids = [ data.azurerm_key_vault.kv.id ]
  action {
    action_group = [ azurerm_monitor_action_group.ag.id ]
    email_subject = "Secret Expiry_notification"
    custom_webhook_payload = "{}"

  }
  data_source_id = data.azurerm_key_vault.kv.id
  enabled = true

  query = <<-QUERY
    AzureDiagnostics
        | where OperationName contains "SecretNearExpiry" 
        | summarize secretexpiring = count () by format_datetime(eventGridEventProperties_eventTime_t, 'dd-MM-yyyy')
    QUERY
# 

  severity = 2
  frequency = 5
  time_window = 5

  trigger {
    operator = "GreaterThanOrEqual"
    threshold = 1
  }

}