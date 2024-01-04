# Note: The bucket name may not work for you since buckets are unique globally in AWS, so you must give it a unique name.
resource "aws_s3_bucket" "terraform_state" {
  bucket = "dev-terraform-bucket-sai"
  # Enable versioning so we can see the full revision history of our state files

}

resource "aws_s3_bucket_versioning" "terraform_versioning" {

  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

module "VPC" {
  source                              = "./modules/VPC"
  region                              = var.region
  vpc_cidr                            = var.vpc_cidr
  tags                                = var.tags
  name                                = var.name
  enable_dns_support                  = var.enable_dns_support
  enable_dns_hostnames                = var.enable_dns_hostnames
  preferred_number_of_public_subnets  = var.preferred_number_of_public_subnets
  preferred_number_of_private_subnets = var.preferred_number_of_private_subnets
  private_subnets                     = [for i in range(1, 8, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  public_subnets                      = [for i in range(2, 5, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
}

module "security" {
  source = "./modules/Security"
  tags   = var.tags
  name   = var.name
  vpc_id = module.VPC.vpc_id



}

module "RDS" {
  source          = "./modules/RDS"
  name            = var.name
  master-password = var.master-password
  master-username = var.master-password
  db-sg           = module.security.datalayer-sg
  private_subnets = [module.VPC.private_subnets-3, module.VPC.private_subnets-4]

}

module "EFS" {
  source       = "./modules/EFS"
  name         = var.name
  tags         = var.tags
  account_no   = var.account_no
  efs-subnet-1 = module.VPC.private_subnets-1
  efs-subnet-2 = module.VPC.private_subnets-2
  efs-sg       = [module.security.datalayer-sg]

}

module "Autoscaling" {
  source            = "./modules/Autoscaling"
  keypair           = var.keypair
  tags              = var.tags
  name              = "DEV"
  ami-web           = var.ami
  instance_profile  = module.VPC.instance_profile
  ami-bastion       = var.ami
  web-sg            = [module.security.web-sg]
  bastion-sg        = [module.security.bastion-sg]
  nginx-sg          = [module.security.nginx-sg]
  private_subnets   = [module.VPC.private_subnets-1, module.VPC.private_subnets-2]
  public_subnets    = [module.VPC.public_subnets-1, module.VPC.public_subnets-2]
  ami-nginx         = var.ami
  nginx-alb-tgt     = module.ALB.nginx-tgt
  wordpress-alb-tgt = module.ALB.wordpress-tgt
  tooling-alb-tgt   = module.ALB.tooling-tgt
  max_size          = 2
  min_size          = 2
  desired_capacity  = 2



}

module "ALB" {
  source             = "./modules/ALB"
  name               = "dev-ext-alb"
  public-sg          = module.security.ALB-sg
  private-sg         = module.security.IALB-sg
  public-sbn-1       = module.VPC.public_subnets-1
  public-sbn-2       = module.VPC.public_subnets-2
  private-sbn-1      = module.VPC.private_subnets-1
  private-sbn-2      = module.VPC.private_subnets-2
  ip_address_type    = "ipv4"
  vpc_id             = module.VPC.vpc_id
  load_balancer_type = "application"


}