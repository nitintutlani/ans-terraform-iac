variable "project_name" {
  type        = string
  description = "A unique name for your deployment project"
}

variable "cidr" {
  type        = string
  description = "The CIDR block for the VPC"
  default = "10.0.0.0/16"
}

variable "private_subnet_count" {
  type        = number
  description = "The number of private subnets to create"
}

variable "public_subnet_count" {
  type        = number
  description = "The number of public subnets to create"
}