variable min_size {
  type        = string
  default     = "1"
  description = "Min size for ASG"
}

variable max_size {
  type        = string
  default     = "3"
  description = "Max size for ASG"
}

variable desired_size {
  type        = string
  default     = "1"
  description = "Desired size for ASG"
}

variable ami_id {
  type        = string
  default     = "ami-0ebc1ac48dfd14136"
  description = "AMI for the EC2 instance"
}

variable instance_type {
  type        = string
  default     = "t2.micro"
  description = "Type of the instance to be created"
}

variable keys {
  type        = string
  default     = "mediawiki"
  description = "KeyPair for the EC2, Used for SSH"
}

variable security_groups_ec2 {
  type        = string
  default     = "sg-01c52786eed159611"
  description = "Security Groups for EC2"
}

variable security_groups_elb {
  type        = string
  default     = "sg-0425f9a00c9df1c3a"
  description = "Security Groups for ELB"
}

variable subnets {
  type        = string
  default     = "subnet-b82306d0"
  description = "Subnets for EC2 and ELB"
}

variable iam_role {
  type        = string
  default     = "media-wiki-iam-role"
  description = "IAM instance profile which is attached to EC2"
}

output min_size {
  value       = var.min_size
}

output max_size {
  value       = var.max_size
}

output desired_size {
  value       = var.desired_size
}

output ami_id {
  value       = var.ami_id
}

output instance_type {
  value       = var.instance_type
}

output keys {
  value       = var.keys
}

output security_groups_ec2 {
  value       = var.security_groups_ec2
}

output security_groups_elb {
  value       = var.security_groups_elb
}

output subnets {
  value       = var.subnets
}

output iam_role {
  value       = var.iam_role
}