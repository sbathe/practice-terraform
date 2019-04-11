provider "aws" {
  region = "ap-south-1"
  profile = "tf"
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = "${module.vpc.vpc_id}"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.60.0"

  name = "webapp-deploy"

  cidr = "10.0.0.0/16"

  azs                 = ["ap-south-1a", "ap-south-1b"]
  private_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets      = ["10.0.11.0/24", "10.0.12.0/24"]
  database_subnets    = ["10.0.21.0/24", "10.0.22.0/24"]

  create_database_subnet_group = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

  # enable_vpn_gateway = true

  enable_dhcp_options              = true
  dhcp_options_domain_name         = "service.consul"
  dhcp_options_domain_name_servers = ["127.0.0.1", "10.10.0.2"]

  # VPC endpoint for S3
  enable_s3_endpoint = false

  # VPC endpoint for DynamoDB
  enable_dynamodb_endpoint = false

  # VPC endpoint for SSM
  enable_ssm_endpoint              = false
#  ssm_endpoint_private_dns_enabled = true
#  ssm_endpoint_security_group_ids  = ["${data.aws_security_group.default.id}"] # ssm_endpoint_subnet_ids = ["..."]

  # VPC endpoint for SSMMESSAGES
  enable_ssmmessages_endpoint              = false
#  ssmmessages_endpoint_private_dns_enabled = true
#  ssmmessages_endpoint_security_group_ids  = ["${data.aws_security_group.default.id}"]

  # VPC Endpoint for EC2
  enable_ec2_endpoint              = false
#  ec2_endpoint_private_dns_enabled = true
#  ec2_endpoint_security_group_ids  = ["${data.aws_security_group.default.id}"]

  # VPC Endpoint for EC2MESSAGES
  enable_ec2messages_endpoint              = false
#  ec2messages_endpoint_private_dns_enabled = true
#  ec2messages_endpoint_security_group_ids  = ["${data.aws_security_group.default.id}"]

  # VPC Endpoint for ECR API
  enable_ecr_api_endpoint              = false
#  ecr_api_endpoint_private_dns_enabled = true
#  ecr_api_endpoint_security_group_ids  = ["${data.aws_security_group.default.id}"]

  # VPC Endpoint for ECR DKR
  enable_ecr_dkr_endpoint              = false
#  ecr_dkr_endpoint_private_dns_enabled = true
#  ecr_dkr_endpoint_security_group_ids  = ["${data.aws_security_group.default.id}"]

  tags = {
    Owner       = "webapp_user"
    Environment = "staging"
    Name        = "webapp_vpc"
  }
}
