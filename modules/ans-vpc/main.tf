data "aws_availability_zones" "available" {
    state = "available"
}

locals {
    az_count = length(data.aws_availability_zones.available.names)

  public_subnet_cidr_blocks = [
    for i in range(var.public_subnet_count) : cidrsubnet(var.cidr, 8, i)
  ]

  private_subnet_cidr_blocks = [
    for i in range(var.private_subnet_count) : cidrsubnet(var.cidr, 8, var.public_subnet_count + i)
  ]
}

resource "aws_vpc" "this" {
  cidr_block = var.cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  count = var.public_subnet_count

  cidr_block        = local.public_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.vpc_name}-public-subnet-${count.index}"
  }

  vpc_id = aws_vpc.this.id
}

resource "aws_subnet" "private" {
  count = var.private_subnet_count

  cidr_block        = local.private_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.vpc_name}-private-subnet-${count.index}"
  }

  vpc_id = aws_vpc.this.id
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  count = var.public_subnet_count

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_security_group" "public" {
  name_prefix = "${var.vpc_name}-public-sg"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private" {
  name_prefix = "${var.vpc_name}-private-sg"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [for subnet in aws_subnet.public : subnet.cidr_block]
  }
}
