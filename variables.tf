variable "project_name" {
  type = string
  description = "A unique name for your deployment project"
}

variable "instance_count" {
  type = number
  description = "The number of instances to create"
  default = 2
}

variable "az_count" {
  type = number
  description = "The number of azs to create subnets in"
  default = 2
}

variable "instance_type" {
  type = string
  description = "The type of instance to create"
  default = "t2.micro"
}
