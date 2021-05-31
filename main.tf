provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr_block

  azs             = [var.avail_zone_1, var.avail_zone_2]
  private_subnets = [var.pri_1_subnet, var.pri_2_subnet]
  public_subnets  = [var.pub_1_subnet, var.pub_2_subnet]


  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = var.env_prefix
  }
}
resource "aws_security_group" "sg1" {
  name        = "SG FOR EC2"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }
  ingress {
    description = "nginx VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name      = var.env_prefix
    Terraform = true
  }
}
resource "aws_key_pair" "my-key" {
  key_name   = "my-key"
  public_key = file("tf_ec2_key.pub")
  tags = {
    Terraform   = "true"
    Environment = var.env_prefix
  }
}
resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.latest_amazon_linux_ami.id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.sg1.id]
  availability_zone           = var.avail_zone_1
  associate_public_ip_address = true
  key_name                    = aws_key_pair.my-key.key_name
  user_data                   = file("script.sh")
  tags = {
    Terraform   = "true"
    Environment = var.env_prefix
  }
}