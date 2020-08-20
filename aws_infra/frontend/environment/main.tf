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
    region  = "ap-south-1"
    encrypt = true
  }
}

# Loading Constants module
module constants {
  source = "../constants"
}

locals {
  min_size      = module.constants.min_size
  max_size      = module.constants.max_size
  desired_size  = module.constants.desired_size
  ami_id        = module.constants.ami_id
  instance_type = module.constants.instance_type
  keys          = module.constants.keys
  subnets       = module.constants.subnets
  iam_role      = module.constants.iam_role
  security_groups_ec2 =  module.constants.security_groups_ec2
  security_groups_elb = module.constants.security_groups_elb
}


# Module to pass required params
module resources {
  source = "../resources"
  region = "south"
  keep   = var.keep
  color  = var.color
  wiki_version = var.wiki_version

  min_size     = local.min_size
  max_size     = local.max_size
  desired_size = local.desired_size
  ami_id       = local.ami_id
  instance_type= local.instance_type
  keys         = local.keys
  subnets      = local.subnets
  iam_role     = local.iam_role
  security_groups_ec2 = local.security_groups_ec2
  security_groups_elb = local.security_groups_elb
}