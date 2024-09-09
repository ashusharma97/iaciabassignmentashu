variable "prefix" {
  type        = string
  description = "Prefix to many of the resources created which helps as an identifier, could be company name, solution name, etc"
}

variable "region" {
  type        = string
  description = "Region to deploy the solution"
}

variable "db_username" {
  type        = string
  description = "Database username"
}

variable "db_address" {
  type        = string
  description = "Database address"
}

variable "db_name" {
  type        = string
  description = "Database name"
}

variable "db_secret_arn" {
  type        = string
  description = "ARN for the database password in secret manager"
}

variable "db_secret_key_id" {
  type        = string
  description = "Key Id for the database password in secret manager"
}

variable "vpc_id" {
  type        = string
  description = "VPC Id"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet Ids"
}

variable "alb_security_group_id" {
  type        = string
  description = "ALB security group Id"
}

variable "alb_target_group_arn" {
  type        = string
  description = "ALB target group arn"
}
