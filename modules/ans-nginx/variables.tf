variable "instance_count" {
  type        = number
  description = "The number of instances to create"
}

variable "instance_type" {
  type        = string
  description = "The instance type for the instances"
}

variable "project_name" {
  type        = string
  description = "A unique name for your deployment project"
}

variable "vpc_id" {
  type        = string
  description = "Vpc id to launch the instances in"
}

variable "subnet_ids" {
  type        = list(string)
  description = "The IDs of the public subnets to launch the instances in"
}

variable "security_group_id" {
  type        = string
  description = "The ID of the public security group to associate with the instances"
}
