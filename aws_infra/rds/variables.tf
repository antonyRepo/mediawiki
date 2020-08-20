variable name {
  type        = string
  default     = "media_wiki_rds"
  description = "Name of the RDS instance"
}

variable storage_type {
  type        = string
  default     = "gp2"
  description = "DB storage type"
}

variable engine {
  type        = string
  default     = "mysql"
  description = "DB Engine type"
}

variable engine_version {
  type        = string
  default     = "5.7"
  description = "The engine version to use"
}

variable identifier {
  type        = string
  default     = "media-wiki-rds"
  description = "Name of the RDS instance"
}

variable instance_class {
  type        = string
  default     = "db.t2.micro"
  description = "DB instance class to meet processing requirements"
}

variable parameter_group_name {
  type        = string
  default     = "default.mysql5.7"
  description = "Name of the DB parameter group to associate"
}

variable allocated_storage {
  type        = string
  default     = "20"
  description = "Storage size in GB"
}

variable vpc_security_group_ids {
  type        = string
  default     = "sg-00b2119705c42c634"
  description = "SG's for RDS instance"
}

variable username {}

variable password {}