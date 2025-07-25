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


variable "environment_name" {
  description = "The name of the Container App Environment"
  type        = string
}

variable "location" {
  description = "The location where the Container App Environment will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "infrastructure_subnet_id" {
  description = "The ID of the subnet for the Container App Environment infrastructure"
  type        = string
}

variable "internal_load_balancer_enabled" {
  description = "Should the Container Environment operate in Internal Load Balancing Mode?"
  type        = bool
  default     = true
}

variable "container_apps" {
  description = "A map of container apps to create"
  type = map(object({
    name          = string
    revision_mode = string
    identity = object({
      type         = string
      identity_ids = list(string)
    })
    registry = object({
      server   = string
      identity = string
    })
    ingress = optional(object({
      external_enabled = bool
      target_port      = number
      transport        = string
      ip_security_restrictions = list(object({
        name             = string
        description      = string
        action           = string
        ip_address_range = string
      }))
      traffic_weight = object({
        latest_revision = bool
        percentage      = number
      })
    }))
    template = object({
      container = object({
        name   = string
        image  = string
        cpu    = number
        memory = string
      })
    })
  }))
  default = {}
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "workload_profile_name" {
  description = "The ID of the subnet for the Container App Environment infrastructure"
  type        = string
  default     = "gp-d4"
}
variable "workload_profile_type" {
  description = "The ID of the subnet for the Container App Environment infrastructure"
  type        = string
  default     = "D4"
}
variable "workload_minimum_count" {
  description = "The ID of the subnet for the Container App Environment infrastructure"
  type        = number
  default     = 1
}
variable "workload_maximum_count" {
  description = "The ID of the subnet for the Container App Environment infrastructure"
  type        = number
  default     = 10
}
