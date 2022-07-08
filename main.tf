provider "nomad" {
  address = join("",["http://", data.aws_instances.nomad_server.private_ips[1], ":4646"])
}

data "aws_instances" "nomad_server" {

  filter {
    name   = "tag:Name"
    values = ["*nomad-server"]
  }
}

module "efs" {
  source = "cloudposse/efs/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version     = "0.32.7"

  for_each        = var.names
  name            = each.key
  region          = var.region
  vpc_id          = var.vpc_id
  subnets         = var.subnet_ids
  security_groups = var.security_group_ids
}

data "nomad_plugin" "efs" {
  plugin_id        = "aws-efs0"
  wait_for_healthy = true
}

resource "nomad_volume" "efs_volume" {
  for_each    = var.names
  depends_on  = [data.nomad_plugin.efs]
  type        = "csi"
  plugin_id   = "aws-efs0"
  volume_id   = each.key
  name        = each.key
  external_id = module.efs[each.key].id

  capability {
    access_mode     = "multi-node-multi-writer"
    attachment_mode = "file-system"
  }

  mount_options {
    fs_type = "ext4"
  }
}
