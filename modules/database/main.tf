resource "aws_rds_cluster" "service_db_cluster" {
  cluster_identifier              = "${var.service_name}-${var.short_env}-aurora-${var.engine}"
  availability_zones              = var.availability_zones
  engine_mode                     = "serverless"
  database_name                   = var.name
  master_username                 = var.user
  master_password                 = var.password
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.mysql_56.name
  backup_retention_period         = 1
  preferred_backup_window         = var.backup_window
  preferred_maintenance_window    = var.maintenance_window
  db_subnet_group_name            = aws_db_subnet_group.service_db.name
  apply_immediately               = true
  vpc_security_group_ids          = [aws_security_group.service_db.id]
  skip_final_snapshot             = true

  scaling_configuration {
    auto_pause               = true
    max_capacity             = 8
    min_capacity             = 1
    seconds_until_auto_pause = 300
    timeout_action           = "RollbackCapacityChange"
  }

  tags = {
    Name        = "${var.service_name}-${var.short_env}-aurora-cluster"
    Environment = var.environment
    Service     = var.service_name
  }
}

resource "aws_rds_cluster_parameter_group" "mysql_56" {
  name   = "${var.service_name}-${var.short_env}-aurora-pg-56"
  family = "aurora5.6"
  description = "Aurora cluster parameter group"

  parameter {
    name         = "performance_schema"
    value        = "1"
    apply_method = "pending-reboot"
  }

  tags = {
    Name        = "${var.service_name}-${var.short_env}-params"
    Environment = var.environment
    Service     = var.service_name
  }
}

resource "aws_db_subnet_group" "service_db" {
  name        = "${var.service_name}-${var.short_env}-aurora-${var.engine}-subnet"
  description = "${var.service_name} db subnet for ${var.environment}"
  subnet_ids  = var.db_subnet

  tags = {
    Name        = "${var.service_name}-${var.short_env}-db-subnet"
    Environment = var.environment
    Service     = var.service_name
  }
}

resource "aws_security_group" "service_db" {
  vpc_id      = var.target_vpc
  name        = "${var.service_name}-${var.short_env}-rds"
  description = "Security Group for RDS ${var.service_name} ${var.environment}"

  tags = {
    Name        = "${var.service_name}-${var.short_env}-rds"
    Environment = var.environment
    Service     = var.service_name
  }
}

resource "aws_security_group_rule" "vpc_cidr_ingress" {
  type        = "ingress"
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  cidr_blocks = [var.vpc_cidr_block]

  security_group_id = aws_security_group.service_db.id
}

resource "aws_security_group_rule" "developers_ingress" {
  type        = "ingress"
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  cidr_blocks = var.developers_site

  security_group_id = aws_security_group.service_db.id
}

resource "aws_security_group_rule" "service_db_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.service_db.id
}
