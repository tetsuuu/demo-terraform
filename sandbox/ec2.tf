module "bastion" {
  source = "../modules/ec2"

  common_key      = "sandbox_dev"  //TODO
  instance_type   = "t2.micro"  //TODO
  environment     = var.environment
  region          = var.region
  service_name    = var.service_name
  short_env       = var.short_env
  developers_site = var.developers_site
  public_subs     = module.service_vpc.public_subnets
  service_vpc     = module.service_vpc.vpc_id
  db_sg           = module.aws_db_instance.db_sg
}
