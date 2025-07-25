# Terraform Files Prepared by: Systemnet Pty Ltd
# IaC Code Authors: sanju khetavath
# Date: 18/07/2025
# Last Modified: 18/07/2025
# Version: 1.1
# Contact: skhetavath@sn.com.au
# Project: Azure Digital Twin Infrastructure
# Non-Production Azure Digital Twin Infrastructure
# This Terraform configuration is designed for non-production environments only
# Do not use for production workloads without proper review and modifications


output "environment_id" {
  description = "The ID of the Container App Environment"
  value       = azurerm_container_app_environment.this.id
}

output "environment_name" {
  description = "The name of the Container App Environment"
  value       = azurerm_container_app_environment.this.name
}

output "container_apps" {
  description = "A map of container apps created"
  value = {
    for k, v in azurerm_container_app.apps : k => {
      id   = v.id
      name = v.name
    }
  }
}

output "container_app_ids" {
  description = "A map of container app names to their IDs"
  value = {
    for k, v in azurerm_container_app.apps : k => v.id
  }
}


output "principal_ids" {
  value = {
    for app_name, app in azurerm_container_app.apps :
    app_name => app.identity[0].principal_id
  }
}
