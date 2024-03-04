locals {
  az_count = min(var.az_count, length(data.aws_availability_zones.available.names))

  public_subnet_cidr_blocks = [
    for i in range(var.az_count) : cidrsubnet(var.cidr, 8, i)
  ]

  private_subnet_cidr_blocks = [
    for i in range(var.az_count) : cidrsubnet(var.cidr, 8, var.az_count + i)
  ]
}
