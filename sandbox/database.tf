module "aws_db_instance" {
  source = "../modules/database"

  environment                  = var.environment
  service_name                 = var.service_name
  short_env                    = var.short_env
  maintenance_cidr_blocks      = var.cidr_block
  storage                      = 20
  max_storage                  = 100
  engine                       = "mysql"
  engine_version               = "5.7.22"
  publicly_accessible          = true
  instance_class               = "db.m5.large"
  name                         = "serverless" // TODO
  user                         = "" // TODO
  password                     = "" // TODO
  backup_window                = "18:00-18:30"
  maintenance_window           = "Sun:18:30-Sun:19:00"
  db_subnet                    = module.service_vpc.public_subnets  //TODO
  target_vpc                   = module.service_vpc.vpc_id
  vpc_cidr_block               = var.cidr_block
  deletion_protection          = false
  skip_final_snapshot          = true
  auto_minor_version_upgrade   = false
  apply_immediately            = true
  performance_insights_enabled = true
  developers_site              = var.developers_site
  availability_zones           = ["us-east-1a", "us-east-1b"]
}
