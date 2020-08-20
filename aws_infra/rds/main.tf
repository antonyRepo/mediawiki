# Cloud Provider
provider aws {
   profile = "antony_manoj"
   region  = "ap-south-1"
}

# Terraform Backend configuation to store state files
terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket  = "media-wiki-thoughtworks"
    key     = "state-files/backend-rds/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}

# RDS DB Instance
resource "aws_db_instance" "media_wiki" {
  count             = 1
  name              = var.name
  storage_type      = var.storage_type
  engine            = var.engine
  engine_version    = var.engine_version
  identifier        = var.identifier   

  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  parameter_group_name   = var.parameter_group_name
  vpc_security_group_ids = [ var.vpc_security_group_ids ]

  username          = var.username
  password          = var.password
}