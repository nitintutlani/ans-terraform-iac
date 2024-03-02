variable "vpc_name" {
  type        = string
  description = "The name for the VPC"
}

variable "cidr" {
  type        = string
  description = "The CIDR block for the VPC"
  default = "10.0.0.0/16"
}

variable "private_subnet_count" {
  type        = number
  description = "The number of private subnets to create"
  default = 3
}

variable "public_subnet_count" {
  type        = number
  description = "The number of public subnets to create"
  default = 3
}