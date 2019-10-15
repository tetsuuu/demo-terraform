terraform {
  backend "s3" {
    bucket = "" //TODO
    key    = "terraform/sandbox/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
