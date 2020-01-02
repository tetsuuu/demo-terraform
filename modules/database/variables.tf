variable "environment" {}
variable "service_name" {}
variable "short_env" {}
variable "maintenance_cidr_blocks" {}
variable "storage" {}
variable "max_storage" {}
variable "engine" {}
variable "engine_version" {}
variable "instance_class" {}
variable "name" {}
variable "user" {}
variable "password" {}
variable "backup_window" {}
variable "publicly_accessible" {}
variable "maintenance_window" {}
variable "target_vpc" {}
variable "db_subnet" {}
variable "vpc_cidr_block" {}
variable "deletion_protection" {}
variable "skip_final_snapshot" {}
variable "auto_minor_version_upgrade" {}
variable "apply_immediately" {}
variable "performance_insights_enabled" {}
variable "developers_site" {}
variable "availability_zones" {}



locals {
  log_level = {
    "default" = ["error"]
    "debug"   = ["audit", "error", "general", "slowquery"]
  }
}
