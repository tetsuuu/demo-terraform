variable "environment" {
  default = "sandbox"
}

variable "region" {
  default = "us-east-1"
}

variable "service_name" {
  default = "proxy"
}

variable "short_env" {
  default = "sand"
}

variable "developers_site" {
  type = "list"
  default = [ //TODO
  ]
}

variable "cidr_block" {
  default = "192.168.0.0/16"
}

variable "availability_zone" {
  default = {
    "us-east-1a" = 1
    "us-east-1b" = 2
  }
}

