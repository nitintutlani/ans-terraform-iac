provider "aws" {
  region = "us-east-1"
}

module "ans-vpc" {
    source  = "./modules/ans-vpc"
    vpc_name = "ans-vpc"
}
