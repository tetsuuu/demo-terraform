module "service_vpc" {
  source = "../modules/vpc"

  environment       = var.environment
  service_name      = var.service_name
  short_env         = var.short_env
  cidr_block        = var.cidr_block
  availability_zone = var.availability_zone
}
