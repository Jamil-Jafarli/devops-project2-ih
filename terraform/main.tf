terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
  use_oidc = true
}

provider "random" {}
provider "tls" {}

locals {
  rg_name  = "devops-project-2-group-2"
  location = "West Europe"

  frontend_pool_name          = "frontend-backend-pool"
  api_pool_name               = "api-backend-pool"
  frontend_http_settings_name = "frontend-http-settings"
  api_http_settings_name      = "api-http-settings"
  agw_frontend_ip_name        = "agw-frontend-ip"
  agw_frontend_port_name      = "agw-frontend-port"
  agw_listener_name           = "agw-http-listener"
  agw_routing_rule_name       = "agw-routing-rule"
  agw_url_path_map_name       = "agw-url-path-map"
  agw_api_path_rule_name      = "agw-api-path-rule"
}
