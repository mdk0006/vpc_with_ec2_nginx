provider "aws" {
  region            = var.region
  access_key    = "AKIATADWNDBTDCMAAGMP"
  secret_key = "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"
}
//  tags = {
//     Name = ""${var.env_prefix}-vpc""
//   }

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr_block

  azs             = [var.avail_zone_1,var.avail_zone_2]
  private_subnets = [var.pri_1_subnet,var.pri_2_subnet]
  public_subnets  = [var.pub_1_subnet, var.pub_2_subnet]


  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "${var.env_prefix}"
  }
}
