vsphere_server = "vcenter.example.com"
# support for self signed certs
#vsphere_server_allow_unverified_ssl = true
vsphere_user = "username"
vsphere_password = "password"
vsphere_datacenter = "DATACENTER-NAME"
vsphere_datastore = "DATASTORE-NAME"
vsphere_resource_pool = "RESOURCEPOOL-NAME"
vsphere_network = "NETWORK-NAME"
vsphere_virtual_machine = "ubuntu-bionic-cloudimg-amd64"

prefix = "username-rancher"
rke_node_count = 1
rke_kubernetes_version = "v1.20.4-rancher1-1"
rancher_replicas = 1
rancher_version = "v2.5.7"
rancher_server_admin_password = "password"
create_workload_cluster = false
workload_kubernetes_version = "v1.17.11-rancher1-1"

# array of public SSH keys
authorized_keys = [ "ssh-rsa QM9Nr7MkxVibVO9AAV4mMp69+MjnXn90LeT4f5aYKqBVCFDnPi7zKE/N/zYJf95ftdp+TAu/UJ/uvvLc7VdxYF8k9ceqXrMhfyqRD/KzPp70qLXkgsoX5ZgPi2pRwHtKYQb6P4IqgLOWr82QPXsRgorUeU+6TxTEj8/hjlpzLZP/h" ]
vm_username = "ubuntu"
vm_cpus = 4
vm_memory = 8192
vm_disk = 100
