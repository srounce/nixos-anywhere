module "system-build" {
  source = "../nix-build"
  attribute = var.nixos_system_attr
  file = var.file
}

module "partitioner-build" {
  source = "../nix-build"
  attribute = var.nixos_partitioner_attr
  file = var.file
}

locals {
  install_user = var.install_user == null ? var.target_user : var.install_user
}

module "install" {
  source                 = "../install"
  kexec_tarball_url      = var.kexec_tarball_url
  target_user            = local.install_user
  target_host            = var.target_host
  target_port            = var.target_port
  nixos_partitioner      = module.partitioner-build.result.out
  nixos_system           = module.system-build.result.out
  ssh_private_key        = var.ssh_private_key
  debug_logging          = var.debug_logging
  instance_id            = var.instance_id
}

module "nixos-rebuild" {
  depends_on = [
    module.install
  ]
  source = "../nixos-rebuild"
  nixos_system = module.system-build.result.out
  target_host = var.target_host
  target_user = var.target_user
  ssh_private_key = var.ssh_private_key
}
