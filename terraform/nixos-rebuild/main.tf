resource "null_resource" "nixos-rebuild" {
  triggers = {
    store_path = var.nixos_system
  }
  provisioner "local-exec" {
    command = "${path.module}/deploy.sh ${var.nixos_system} ${var.target_user}@${var.target_host} ${var.target_port}"
    environment = {
      SSH_KEY = var.ssh_private_key
    }
  }
}
