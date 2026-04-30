resource "azurerm_web_application_firewall_policy" "main" {
  name                = "burger-builder-waf-policy"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"

      rule_group_override {
        rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
        rule {
          id      = "920300"
          enabled = false
        }
        rule {
          id      = "920320"
          enabled = false
        }
      }
    }
  }

  policy_settings {
    enabled                     = true
    mode                        = "Prevention"
    file_upload_limit_in_mb     = 30
    max_request_body_size_in_kb = 128
    request_body_check          = true
  }
}

resource "azurerm_application_gateway" "main" {
  name                = "burger-builder-agw"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  firewall_policy_id = azurerm_web_application_firewall_policy.main.id

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "agw-ip-config"
    subnet_id = azurerm_subnet.agw.id
  }

  frontend_ip_configuration {
    name                 = local.agw_frontend_ip_name
    public_ip_address_id = azurerm_public_ip.agw.id
  }

  frontend_port {
    name = local.agw_frontend_port_name
    port = 80
  }

  backend_address_pool {
    name         = local.frontend_pool_name
    ip_addresses = ["10.0.1.68"]
  }

  backend_address_pool {
    name         = local.api_pool_name
    ip_addresses = ["10.0.1.68"]
  }

  probe {
    name                = "frontend-health-probe"
    host                = "10.0.1.68"
    protocol            = "Http"
    path                = "/"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-599"]
    }
  }

  probe {
    name                = "api-health-probe"
    host                = "10.0.1.68"
    protocol            = "Http"
    path                = "/api/ingredients"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    match {
      status_code = ["200-599"]
    }
  }

  backend_http_settings {
    name                  = local.frontend_http_settings_name
    cookie_based_affinity = "Disabled"
    port                  = 5173
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = "frontend-health-probe"
  }

  backend_http_settings {
    name                  = local.api_http_settings_name
    cookie_based_affinity = "Disabled"
    port                  = 8080
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = "api-health-probe"
  }

  http_listener {
    name                           = local.agw_listener_name
    frontend_ip_configuration_name = local.agw_frontend_ip_name
    frontend_port_name             = local.agw_frontend_port_name
    protocol                       = "Http"
  }

  url_path_map {
    name                               = local.agw_url_path_map_name
    default_backend_address_pool_name  = local.frontend_pool_name
    default_backend_http_settings_name = local.frontend_http_settings_name

    path_rule {
      name                       = local.agw_api_path_rule_name
      paths                      = ["/api/*"]
      backend_address_pool_name  = local.api_pool_name
      backend_http_settings_name = local.api_http_settings_name
    }
  }

  request_routing_rule {
    name               = local.agw_routing_rule_name
    rule_type          = "PathBasedRouting"
    http_listener_name = local.agw_listener_name
    url_path_map_name  = local.agw_url_path_map_name
    priority           = 10
  }
}
