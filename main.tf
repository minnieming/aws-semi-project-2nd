# Amazon Linux 2023 AMI 자동조회 (서울리전 전용)
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

locals {
  ami_id = data.aws_ami.al2023.id
}

# 1) VPC + Subnets + IGW + NAT Gateway + Route tables
module "vpc" {
  source = "./modules/vpc"

  name = var.project_name
}

# 2) Security Groups
module "security" {
  source = "./modules/security"

  name        = var.project_name
  vpc_id      = module.vpc.vpc_id
  vpc_cidr    = module.vpc.vpc_cidr
  my_ip_cidr  = var.my_ip_cidr
}

# 3) ALB
module "alb" {
  source = "./modules/alb"

  name              = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  sg_alb_id         = module.security.sg_alb_id
}

# 4) Web ASG
module "asg_web" {
  source = "./modules/asg_web"

  name                   = var.project_name
  ami_id                 = local.ami_id
  instance_type          = var.instance_type_web
  private_web_subnet_ids = module.vpc.private_web_subnet_ids
  sg_web_id              = module.security.sg_web_id
  tg_web_arn             = module.alb.tg_web_arn
}

# 5) Bastion Host
module "bastion" {
  source = "./modules/bastion"

  name          = var.project_name
  ami_id        = local.ami_id
  instance_type = var.instance_type_bastion
  subnet_id     = module.vpc.public_bastion_subnet_id
  sg_bastion_id = module.security.sg_bastion_id
  key_name      = var.key_name
}

