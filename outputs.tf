resource "local_file" "ansible_inventory" {
  filename = "${path.module}/hosts.ini"
  content  = <<EOT
[all_servers]
${yandex_compute_instance.devops_vm.network_interface.0.nat_ip_address} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa
EOT
}
