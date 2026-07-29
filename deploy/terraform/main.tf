terraform {
  required_version = ">= 1.0"

  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "~> 1.60"
    }
  }
}

provider "huaweicloud" {
  region = var.region
}

resource "huaweicloud_vpc" "main" {
  name = "${var.environment_name}-vpc"
  cidr = "10.0.0.0/16"
}

resource "huaweicloud_vpc_subnet" "subnet_a" {
  name              = "${var.environment_name}-subnet-a"
  vpc_id            = huaweicloud_vpc.main.id
  cidr              = "10.0.1.0/24"
  gateway_ip        = "10.0.1.1"
  availability_zone = "${var.region}a"
  primary_dns       = "100.125.1.250"
  secondary_dns     = "100.125.21.250"
}

resource "huaweicloud_vpc_subnet" "subnet_b" {
  name              = "${var.environment_name}-subnet-b"
  vpc_id            = huaweicloud_vpc.main.id
  cidr              = "10.0.2.0/24"
  gateway_ip        = "10.0.2.1"
  availability_zone = "${var.region}b"
  primary_dns       = "100.125.1.250"
  secondary_dns     = "100.125.21.250"
}

resource "huaweicloud_cce_cluster" "main" {
  name                   = "${var.environment_name}-cce"
  flavor_id              = "cce.s1.small"
  vpc_id                 = huaweicloud_vpc.main.id
  subnet_id              = huaweicloud_vpc_subnet.subnet_a.id
  container_network_type = "overlay_l2"
  container_network_cidr = "172.16.0.0/16"
  authentication_mode    = "rbac"
}

resource "huaweicloud_cce_node_pool" "main" {
  cluster_id         = huaweicloud_cce_cluster.main.id
  name               = "${var.environment_name}-node-pool"
  flavor_id          = var.cce_node_flavor
  initial_node_count = var.cce_node_count
  availability_zone  = "${var.region}a"

  scale_enable              = true
  min_node_count            = 1
  max_node_count            = 5
  scale_down_cooldown_time  = 300

  root_volume {
    size       = 40
    volumetype = "SSD"
  }

  data_volumes {
    size       = 100
    volumetype = "SSD"
  }
}

resource "huaweicloud_elb_loadbalancer" "frontend" {
  name           = "${var.environment_name}-elb-frontend"
  vpc_id         = huaweicloud_vpc.main.id
  type           = "External"
  ipv4_subnet_id = huaweicloud_vpc_subnet.subnet_a.ipv4_subnet_id
}

resource "huaweicloud_elb_loadbalancer" "backend" {
  name           = "${var.environment_name}-elb-backend"
  vpc_id         = huaweicloud_vpc.main.id
  type           = "External"
  ipv4_subnet_id = huaweicloud_vpc_subnet.subnet_a.ipv4_subnet_id
}

resource "huaweicloud_obs_bucket" "artifacts" {
  bucket = "${var.environment_name}-artifacts"
  acl    = "private"
}

resource "huaweicloud_obs_bucket" "assets" {
  bucket = "${var.environment_name}-assets"
  acl    = "public-read"
}

resource "huaweicloud_smn_topic" "deploy_notification" {
  name         = "${var.environment_name}-deploy-notify"
  display_name = "Deploy notification for ${var.environment_name}"
}

variable "region" {
  description = "Huawei Cloud region"
  type        = string
  default     = "cn-north-4"
}

variable "environment_name" {
  description = "Environment name used as resource prefix"
  type        = string
}

variable "cce_node_count" {
  description = "Number of CCE nodes"
  type        = number
  default     = 2
}

variable "cce_node_flavor" {
  description = "CCE node flavor"
  type        = string
  default     = "s6.large.#2"
}

output "cluster_name" {
  value = huaweicloud_cce_cluster.main.name
}

output "frontend_elb_address" {
  value = huaweicloud_elb_loadbalancer.frontend
}

output "application_url" {
  value = "http://${huaweicloud_elb_loadbalancer.frontend.address}"
}
