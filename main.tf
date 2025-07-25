resource "azurerm_container_app_environment" "this" {
  name                           = var.environment_name
  location                       = var.location
  resource_group_name            = var.resource_group_name
  infrastructure_subnet_id       = var.infrastructure_subnet_id
  internal_load_balancer_enabled = var.internal_load_balancer_enabled
  workload_profile {
    name                  = var.workload_profile_name
    workload_profile_type = var.workload_profile_type
    minimum_count         = var.workload_minimum_count
    maximum_count         = var.workload_maximum_count
  }
  tags = var.tags

  lifecycle {
    ignore_changes = [
      infrastructure_resource_group_name,
      log_analytics_workspace_id
    ]
  }
}

# Container Apps
resource "azurerm_container_app" "apps" {
  for_each = var.container_apps

  name                         = each.value.name
  container_app_environment_id = azurerm_container_app_environment.this.id
  resource_group_name          = var.resource_group_name
  revision_mode                = each.value.revision_mode

  identity {
    type         = each.value.identity.type
    identity_ids = each.value.identity.identity_ids
  }

  registry {
    server   = each.value.registry.server
    identity = each.value.registry.identity
  }

  dynamic "ingress" {
    for_each = each.value.ingress != null ? [each.value.ingress] : []
    content {
      external_enabled = ingress.value.external_enabled
      target_port      = ingress.value.target_port
      transport        = ingress.value.transport

      dynamic "ip_security_restriction" {
        for_each = ingress.value.ip_security_restrictions
        content {
          name             = ip_security_restriction.value.name
          description      = ip_security_restriction.value.description
          action           = ip_security_restriction.value.action
          ip_address_range = ip_security_restriction.value.ip_address_range
        }
      }

      traffic_weight {
        latest_revision = ingress.value.traffic_weight.latest_revision
        percentage      = ingress.value.traffic_weight.percentage
      }
    }
  }

  template {
    container {
      name   = each.value.template.container.name
      image  = each.value.template.container.image
      cpu    = each.value.template.container.cpu
      memory = each.value.template.container.memory
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      workload_profile_name,
      template[0].revision_suffix,
      registry[0].identity,
      identity,                    
      template,                    
      ingress,       
    ]
  }
}
