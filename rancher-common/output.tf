# Outputs

output "rancher_url" {
  value = "https://${var.rancher_server_dns}"
}

output "custom_cluster_command" {
  value       = var.create_workload_cluster ? rancher2_cluster.quickstart_workload[0].cluster_registration_token.0.node_command : null
  description = "Docker command used to add a node to the quickstart cluster"
}

output "custom_cluster_windows_command" {
  value       = var.create_workload_cluster ?  rancher2_cluster.quickstart_workload[0].cluster_registration_token.0.windows_node_command : null
  description = "Docker command used to add a windows node to the quickstart cluster"
}