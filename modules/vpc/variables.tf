variable "cidr_block" {}
variable "service_name" {}
variable "environment" {}
variable "short_env" {}
variable "availability_zone" {
  default = {
    "us-east-1a" = 1
    "us-east-1b" = 2
  }
}
