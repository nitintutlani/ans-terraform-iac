variable "project_name" {
  type        = string
  description = "A unique name for your deployment project"
}

variable "cidr" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "az_count" {
  type        = number
  description = "The number of azs to create subnets in"
}
