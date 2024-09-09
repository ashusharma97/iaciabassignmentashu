resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  instance_tenancy     = "default"

  tags = {
    Name = format("%s-vpc", var.prefix)
  }
}
data "aws_availability_zones" "available" {}
resource "aws_subnet" "public_subnets" {
  count = var.number_of_public_subnets

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(var.vpc_cidr, 3, count.index)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true

  tags = {
    Name = format("%s-public-subnet-%s", var.prefix, count.index)
  }
}

resource "aws_subnet" "private_subnets" {
  count = var.number_of_private_subnets

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(var.vpc_cidr, 3, count.index + 2)
  vpc_id            = aws_vpc.vpc.id

  tags = {
    Name = format("%s-private-subnet-%s", var.prefix, count.index)
  }
}

resource "aws_subnet" "secure_subnets" {
  count = var.number_of_secure_subnets

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(var.vpc_cidr, 3, count.index + 4)
  vpc_id            = aws_vpc.vpc.id

  tags = {
    Name = format("%s-secure-subnet-%s", var.prefix, count.index)
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = format("%s-igw", var.prefix)
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnets[1].id

  tags = {
    Name = format("%s-nat", var.prefix)
  }
}

resource "aws_route_table" "public_routetable" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = format("%s-public-route-table", var.prefix)
  }
}

resource "aws_route_table" "private_routetable" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = format("%s-private-route-table", var.prefix)
  }
}

resource "aws_route_table_association" "public_subnets" {
  for_each = { for name, subnet in aws_subnet.public_subnets : name => subnet }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_routetable.id
}

resource "aws_route_table_association" "private_subnets" {
  for_each = { for name, subnet in aws_subnet.private_subnets : name => subnet }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_routetable.id
}