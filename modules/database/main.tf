resource "aws_db_instance" "service_db" {
  identifier                      = "${var.service_name}-${var.short_env}-rds-${var.engine}"
  allocated_storage               = var.storage
  max_allocated_storage           = var.max_storage
  storage_type                    = "gp2"
  engine                          = var.engine
  engine_version                  = var.engine_version
  instance_class                  = var.instance_class
  name                            = var.name
  username                        = var.user
  password                        = var.password
  db_subnet_group_name            = aws_db_subnet_group.service_db.name
  publicly_accessible             = var.publicly_accessible
  parameter_group_name            = aws_db_parameter_group.mysql-57.name
  backup_retention_period         = 7
  backup_window                   = var.backup_window
  maintenance_window              = var.maintenance_window
  deletion_protection             = var.deletion_protection
  skip_final_snapshot             = var.skip_final_snapshot
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  apply_immediately               = var.apply_immediately
  vpc_security_group_ids          = [aws_security_group.service_db.id]
  enabled_cloudwatch_logs_exports = local.log_level.debug
  performance_insights_enabled    = var.performance_insights_enabled

  tags = {
    Name        = "${var.service_name}-${var.short_env}-rds"
    Environment = var.environment
    Service     = var.service_name
  }
}

resource "aws_db_parameter_group" "mysql-57" {
  name   = "${var.service_name}-${var.short_env}-rds-pg-57"
  family = "mysql5.7"

  parameter {
    name = "performance_schema"
    value = "1"
    apply_method = "pending-reboot"
  }

  tags = {
    Name        = "${var.service_name}-${var.short_env}-params"
    Environment = var.environment
    Service     = var.service_name
  }
}

resource "aws_db_subnet_group" "service_db" {
  name        = "${var.service_name}-${var.short_env}-rds-${var.engine}-subnet"
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
