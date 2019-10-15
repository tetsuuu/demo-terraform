module "bastion" {
  source = "../modules/ec2"

  common_key    = ""  //TODO
  instance_type = ""  //TODO
  environment   = var.environment
  region        = var.region
  service_name  = var.service_name
  short_env     = var.short_env
  local_ips     = var.local_ips
  public_sub    = var.public_sub
  service_vpc   = var.service_vpc
}
