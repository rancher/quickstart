# Configure the Exoscale Provider
provider "exoscale" {
  key = var.exoscale_key
  secret = var.exoscale_secret
}

variable "exoscale_key" {
  default = "EXOxxx"
}

variable "exoscale_secret" {
  default = "xxx"
}

variable "prefix" {
  default = "yourname"
}

variable "rancher_version" {
  default = "latest"
}

variable "count_agent_all_nodes" {
  default = "3"
}

variable "count_agent_etcd_nodes" {
  default = "0"
}

variable "count_agent_controlplane_nodes" {
  default = "0"
}

variable "count_agent_worker_nodes" {
  default = "0"
}

variable "admin_password" {
  default = "admin"
}

variable "cluster_name" {
  default = "quickstart"
}

variable "zone" {
  default = "at-vie-1"
}

variable "size" {
  default = "Medium"
}

variable "disk_size" {
  type = number
  default = 80
}

variable "security_groups" {
  type = list(string)
  default = ["default"]
}

variable "docker_version_server" {
  default = "18.09"
}

variable "docker_version_agent" {
  default = "18.09"
}

variable "ssh_key" {
  type = string
  default = ""
}

data "exoscale_compute_template" "ubuntu" {
  zone = var.zone
  name = "Linux Ubuntu 18.04 LTS 64-bit"
}

resource "exoscale_compute" "rancherserver" {
  count           = "1"
  template_id     = data.exoscale_compute_template.ubuntu.id
  display_name    = "${var.prefix}-rancherserver"
  zone            = var.zone
  size            = var.size
  user_data       = data.template_file.userdata_server.rendered
  disk_size       = var.disk_size
  key_pair        = var.ssh_key
  security_groups = var.security_groups
}

resource "exoscale_compute" "rancheragent-all" {
  count           = var.count_agent_all_nodes
  template_id     = data.exoscale_compute_template.ubuntu.id
  display_name    = "${var.prefix}-rancheragent-${count.index}-all"
  zone            = var.zone
  size            = var.size
  disk_size       = var.disk_size
  user_data       = data.template_file.userdata_agent.rendered
  key_pair        = var.ssh_key
  security_groups = var.security_groups
}

resource "exoscale_compute" "rancheragent-etcd" {
  count           = var.count_agent_etcd_nodes
  template_id     = data.exoscale_compute_template.ubuntu.id
  display_name    = "${var.prefix}-rancheragent-${count.index}-etcd"
  zone            = var.zone
  size            = var.size
  disk_size       = var.disk_size
  user_data       = data.template_file.userdata_agent.rendered
  key_pair        = var.ssh_key
  security_groups = var.security_groups
}

resource "exoscale_compute" "rancheragent-controlplane" {
  count           = var.count_agent_controlplane_nodes
  template_id     = data.exoscale_compute_template.ubuntu.id
  display_name    = "${var.prefix}-rancheragent-${count.index}-controlplane"
  zone            = var.zone
  size            = var.size
  disk_size       = var.disk_size
  user_data       = data.template_file.userdata_agent.rendered
  key_pair        = var.ssh_key
  security_groups = var.security_groups
}

resource "exoscale_compute" "rancheragent-worker" {
  count           = var.count_agent_worker_nodes
  template_id     = data.exoscale_compute_template.ubuntu.id
  display_name    = "${var.prefix}-rancheragent-${count.index}-worker"
  zone            = var.zone
  size            = var.size
  disk_size       = var.disk_size
  user_data       = data.template_file.userdata_agent.rendered
  key_pair        = var.ssh_key
  security_groups = var.security_groups
}

data "template_file" "userdata_server" {
  template = file("files/userdata_server")

  vars = {
    admin_password        = var.admin_password
    cluster_name          = var.cluster_name
    docker_version_server = var.docker_version_server
    rancher_version       = var.rancher_version
  }
}

data "template_file" "userdata_agent" {
  template = file("files/userdata_agent")

  vars = {
    admin_password       = var.admin_password
    cluster_name         = var.cluster_name
    docker_version_agent = var.docker_version_agent
    rancher_version      = var.rancher_version
    server_address       = exoscale_compute.rancherserver[0].ip_address
  }
}

output "rancher-url" {
  value = ["https://${exoscale_compute.rancherserver[0].ip_address}"]
}

