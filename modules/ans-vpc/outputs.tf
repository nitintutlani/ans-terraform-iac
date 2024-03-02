
output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnet_ids" {
  value = {
    public = aws_subnet.public[*].id
    private = aws_subnet.private[*].id
  }
}

output "security_group_ids" {
  value = {
    public = aws_security_group.public.id
    private = aws_security_group.private.id
  }
}

output "internet_gateway_id" {
  value = aws_internet_gateway.this.id
}
