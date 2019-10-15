variable "environment" {
  default = "sandbox"
}

variable "region" {
  default = "ap-northeast-1"
}

variable "service_name" {
  default = "demo"
}

variable "short_env" {
  default = "snd"
}

variable "local_ips" {
  type = "list"
  default = [ //TODO
    "192.168.31.1/32",
    "192.168.31.2/32"
  ]
}

variable "service_vpc" {
    default = "vpc-12345678"  //TODO
}

variable "public_sub" {
    default = "subnet-12345678"  //TODO
}
