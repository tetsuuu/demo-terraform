terraform {
  backend "s3" {
    bucket = "" //TODO
    key    = "terraform/sandbox/.tfstate" //TODO service_name.tfstate
    region = "us-east-1"
  }
}
