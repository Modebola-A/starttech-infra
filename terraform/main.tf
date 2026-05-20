terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote state storage - uncomment after creating the S3 bucket manually
  # backend "s3" {
  #   bucket = "starttech-terraform-state"
  #   key    = "prod/terraform.tfstate"
  #   region = "eu-west-2"
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# --- Networking Module ---
module "networking" {
  source = "./modules/networking"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

# --- Compute Module ---
module "compute" {
  source = "./modules/compute"

  project_name              = var.project_name
  environment               = var.environment
  vpc_id                    = module.networking.vpc_id
  public_subnet_ids         = module.networking.public_subnet_ids
  alb_security_group_id     = module.networking.alb_security_group_id
  backend_security_group_id = module.networking.backend_security_group_id
  ami_id                    = var.ami_id
  instance_type             = var.instance_type
  asg_desired               = var.asg_desired
  asg_min                   = var.asg_min
  asg_max                   = var.asg_max
}

# --- Storage Module ---
module "storage" {
  source = "./modules/storage"

  project_name = var.project_name
  environment  = var.environment
}

# --- Monitoring Module ---
module "monitoring" {
  source = "./modules/monitoring"

  project_name            = var.project_name
  environment             = var.environment
  aws_region              = var.aws_region
  private_subnet_ids      = module.networking.private_subnet_ids
  redis_security_group_id = module.networking.redis_security_group_id
  alb_arn_suffix          = module.compute.alb_arn
}
