resource "aws_instance" "quickstart_node_win" {
  count         = var.add_windows_node ? 1 : 0
  ami           = data.aws_ami.windows.id
  instance_type = var.windows_instance_type

  key_name          = aws_key_pair.quickstart_key_pair.key_name
  security_groups   = [aws_security_group.rancher_sg_allowall.name]
  get_password_data = true

  user_data = templatefile(
    join("/", [path.module, "files/userdata_quickstart_windows.template"]),
    {
      register_command = module.rancher_common.custom_cluster_windows_command
    }
  )

  root_block_device {
    volume_size = 50
  }

  tags = {
    Name    = "${var.prefix}-quickstart-win"
    Creator = "rancher-quickstart"
  }

}

output "windows_password" {
  description = "Returns the decrypted AWS generated windows password"
  sensitive   = true
  value = [
    for instance in aws_instance.quickstart_node_win :
    rsadecrypt(instance.password_data, tls_private_key.global_key.private_key_pem)
  ]
}

output "windows-workload-ips" {
  value = aws_instance.quickstart_node_win[*].public_ip
}