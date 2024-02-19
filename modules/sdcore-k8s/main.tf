# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_model" "sdcore" {
  count = var.create_model == true ? 1 : 0
  name  = var.model_name
}

module "amf" {
  source     = "git::https://github.com/canonical/sdcore-amf-k8s-operator//terraform"
  model_name = var.create_model == true ? juju_model.sdcore[0].name : var.model_name
  channel    = var.channel
  config     = var.amf_config
}

module "ausf" {
  source     = "git::https://github.com/canonical/sdcore-ausf-k8s-operator//terraform"
  model_name = var.create_model == true ? juju_model.sdcore[0].name : var.model_name
  channel    = var.channel
}

module "nms" {
  source     = "git::https://github.com/canonical/sdcore-nms-k8s-operator//terraform"
  model_name = var.create_model == true ? juju_model.sdcore[0].name : var.model_name
  channel    = var.channel
}

module "nrf" {
  source     = "git::https://github.com/canonical/sdcore-nrf-k8s-operator//terraform"
  model_name = var.create_model == true ? juju_model.sdcore[0].name : var.model_name
  channel    = var.channel
}

module "nssf" {
  source     = "git::https://github.com/canonical/sdcore-nssf-k8s-operator//terraform"
  model_name = var.create_model == true ? juju_model.sdcore[0].name : var.model_name
  channel    = var.channel
  config     = var.nssf_config
}

module "pcf" {
  source     = "git::https://github.com/canonical/sdcore-pcf-k8s-operator//terraform"
  model_name = var.create_model == true ? juju_model.sdcore[0].name : var.model_name
  channel    = var.channel
}

module "smf" {
  source     = "git::https://github.com/canonical/sdcore-smf-k8s-operator//terraform"
  model_name = var.create_model == true ? juju_model.sdcore[0].name : var.model_name
  channel    = var.channel
}

module "udm" {
  source     = "git::https://github.com/canonical/sdcore-udm-k8s-operator//terraform"
  model_name = var.create_model == true ? juju_model.sdcore[0].name : var.model_name
  channel    = var.channel
}

module "udr" {
  source     = "git::https://github.com/canonical/sdcore-udr-k8s-operator//terraform"
  model_name = var.create_model == true ? juju_model.sdcore[0].name : var.model_name
  channel    = var.channel
}

module "webui" {
  source     = "git::https://github.com/canonical/sdcore-webui-k8s-operator//terraform"
  model_name = var.create_model == true ? juju_model.sdcore[0].name : var.model_name
  channel    = var.channel
}

module "mongodb" {
  source     = "../mongodb-k8s"
  model_name = var.create_model == true ? juju_model.sdcore[0].name : var.model_name
  channel    = var.mongo_channel
  config     = var.mongo_config
}

module "grafana-agent" {
  source     = "../grafana-agent-k8s"
  model_name = var.create_model == true ? juju_model.sdcore[0].name : var.model_name
  channel    = var.grafana_agent_channel
  config     = var.grafana_agent_config
}

module "self-signed-certificates" {
  source     = "git::https://github.com/canonical/self-signed-certificates-operator.git//terraform"
  model_name = var.create_model == true ? juju_model.sdcore[0].name : var.model_name
  channel    = var.self_signed_certificates_channel
  config     = var.self_signed_certificates_config
}

module "traefik" {
  source     = "../traefik-k8s"
  model_name = var.create_model == true ? juju_model.sdcore[0].name : var.model_name
  channel    = var.traefik_channel
  config     = var.traefik_config
}

module "upf" {
  source     = "git::https://github.com/canonical/sdcore-upf-k8s-operator//terraform"
  model_name = var.create_model == true ? juju_model.sdcore[0].name : var.model_name
  channel    = var.channel
  config     = var.upf_config
}

# Integrations for `fiveg-nrf` endpoint

resource "juju_integration" "amf-fiveg-nrf" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.amf.app_name
    endpoint = module.amf.fiveg_nrf_endpoint
  }

  application {
    name     = module.nrf.app_name
    endpoint = module.nrf.fiveg_nrf_endpoint
  }
}

resource "juju_integration" "udm-fiveg-nrf" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.udm.app_name
    endpoint = module.udm.fiveg_nrf_endpoint
  }

  application {
    name     = module.nrf.app_name
    endpoint = module.nrf.fiveg_nrf_endpoint
  }
}

resource "juju_integration" "smf-fiveg-nrf" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.smf.app_name
    endpoint = module.smf.fiveg_nrf_endpoint
  }

  application {
    name     = module.nrf.app_name
    endpoint = module.nrf.fiveg_nrf_endpoint
  }
}

resource "juju_integration" "pcf-fiveg-nrf" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.pcf.app_name
    endpoint = module.pcf.fiveg_nrf_endpoint
  }

  application {
    name     = module.nrf.app_name
    endpoint = module.nrf.fiveg_nrf_endpoint
  }
}

resource "juju_integration" "nssf-fiveg-nrf" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.nssf.app_name
    endpoint = module.nssf.fiveg_nrf_endpoint
  }

  application {
    name     = module.nrf.app_name
    endpoint = module.nrf.fiveg_nrf_endpoint
  }
}

resource "juju_integration" "udr-fiveg-nrf" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.udr.app_name
    endpoint = module.udr.fiveg_nrf_endpoint
  }

  application {
    name     = module.nrf.app_name
    endpoint = module.nrf.fiveg_nrf_endpoint
  }
}

resource "juju_integration" "ausf-fiveg-nrf" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.ausf.app_name
    endpoint = module.ausf.fiveg_nrf_endpoint
  }

  application {
    name     = module.nrf.app_name
    endpoint = module.nrf.fiveg_nrf_endpoint
  }
}

# Integrations for `database` endpoint

resource "juju_integration" "amf-database" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.amf.app_name
    endpoint = module.amf.database_endpoint
  }

  application {
    name     = module.mongodb.app_name
    endpoint = module.mongodb.database_endpoint
  }
}

resource "juju_integration" "udr-database" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.udr.app_name
    endpoint = module.udr.database_endpoint
  }

  application {
    name     = module.mongodb.app_name
    endpoint = module.mongodb.database_endpoint
  }
}

resource "juju_integration" "smf-database" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.smf.app_name
    endpoint = module.smf.database_endpoint
  }

  application {
    name     = module.mongodb.app_name
    endpoint = module.mongodb.database_endpoint
  }
}

resource "juju_integration" "pcf-database" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.pcf.app_name
    endpoint = module.pcf.database_endpoint
  }

  application {
    name     = module.mongodb.app_name
    endpoint = module.mongodb.database_endpoint
  }
}

resource "juju_integration" "nrf-database" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.nrf.app_name
    endpoint = module.nrf.database_endpoint
  }

  application {
    name     = module.mongodb.app_name
    endpoint = module.mongodb.database_endpoint
  }
}

resource "juju_integration" "webui-database" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.webui.app_name
    endpoint = module.webui.database_endpoint
  }

  application {
    name     = module.mongodb.app_name
    endpoint = module.mongodb.database_endpoint
  }
}

# Integrations for `metrics` endpoint

resource "juju_integration" "amf-metrics" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.amf.app_name
    endpoint = module.amf.metrics_endpoint
  }

  application {
    name     = module.grafana-agent.app_name
    endpoint = module.grafana-agent.metrics_endpoint
  }
}

resource "juju_integration" "smf-metrics" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.smf.app_name
    endpoint = module.smf.metrics_endpoint
  }

  application {
    name     = module.grafana-agent.app_name
    endpoint = module.grafana-agent.metrics_endpoint
  }
}

resource "juju_integration" "mongodb-metrics" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.mongodb.app_name
    endpoint = module.mongodb.metrics_endpoint
  }

  application {
    name     = module.grafana-agent.app_name
    endpoint = module.grafana-agent.metrics_endpoint
  }
}

resource "juju_integration" "upf-metrics" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.upf.app_name
    endpoint = module.upf.metrics_endpoint
  }

  application {
    name     = module.grafana-agent.app_name
    endpoint = module.grafana-agent.metrics_endpoint
  }
}

# Integrations for `certificates` endpoint

resource "juju_integration" "amf-certificates" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.amf.app_name
    endpoint = module.amf.certificates_endpoint
  }

  application {
    name     = module.self-signed-certificates.app_name
    endpoint = module.self-signed-certificates.certificates_endpoint
  }
}

resource "juju_integration" "udm-certificates" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.udm.app_name
    endpoint = module.udm.certificates_endpoint
  }

  application {
    name     = module.self-signed-certificates.app_name
    endpoint = module.self-signed-certificates.certificates_endpoint
  }
}

resource "juju_integration" "smf-certificates" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.smf.app_name
    endpoint = module.smf.certificates_endpoint
  }

  application {
    name     = module.self-signed-certificates.app_name
    endpoint = module.self-signed-certificates.certificates_endpoint
  }
}

resource "juju_integration" "pcf-certificates" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.pcf.app_name
    endpoint = module.pcf.certificates_endpoint
  }

  application {
    name     = module.self-signed-certificates.app_name
    endpoint = module.self-signed-certificates.certificates_endpoint
  }
}

resource "juju_integration" "nssf-certificates" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.nssf.app_name
    endpoint = module.nssf.certificates_endpoint
  }

  application {
    name     = module.self-signed-certificates.app_name
    endpoint = module.self-signed-certificates.certificates_endpoint
  }
}

resource "juju_integration" "nrf-certificates" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.nrf.app_name
    endpoint = module.nrf.certificates_endpoint
  }

  application {
    name     = module.self-signed-certificates.app_name
    endpoint = module.self-signed-certificates.certificates_endpoint
  }
}

resource "juju_integration" "ausf-certificates" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.ausf.app_name
    endpoint = module.ausf.certificates_endpoint
  }

  application {
    name     = module.self-signed-certificates.app_name
    endpoint = module.self-signed-certificates.certificates_endpoint
  }
}

resource "juju_integration" "udr-certificates" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.udr.app_name
    endpoint = module.udr.certificates_endpoint
  }

  application {
    name     = module.self-signed-certificates.app_name
    endpoint = module.self-signed-certificates.certificates_endpoint
  }
}

# Integrations for `ingress` endpoint

resource "juju_integration" "nms-ingress" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.nms.app_name
    endpoint = module.nms.ingress_endpoint
  }

  application {
    name     = module.traefik.app_name
    endpoint = module.traefik.ingress_endpoint
  }
}

# Integrations for `sdcore-management` endpoint

resource "juju_integration" "nms-sdcore-management" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.nms.app_name
    endpoint = module.nms.sdcore_management_endpoint
  }

  application {
    name     = module.webui.app_name
    endpoint = module.webui.sdcore_management_endpoint
  }
}

# Integrations for `logging` endpoint

resource "juju_integration" "mongodb-logging" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.mongodb.app_name
    endpoint = module.mongodb.logging_endpoint
  }

  application {
    name     = module.grafana-agent.app_name
    endpoint = module.grafana-agent.logging_provider_endpoint
  }
}