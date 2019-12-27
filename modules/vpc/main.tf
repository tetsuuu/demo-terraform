resource "aws_vpc" "service_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true

  tags = {
    Name    = "${var.service_name}-${var.short_env}-vpc"
    Service = var.service_name
    ENV     = var.short_env
  }
}

resource "aws_subnet" "public_subnet" {
  for_each                = var.availability_zone
  cidr_block              = cidrsubnet(aws_vpc.service_vpc.cidr_block, 4, each.value)
  vpc_id                  = aws_vpc.service_vpc.id
  availability_zone       = each.key
  map_public_ip_on_launch = true


  tags = {
    Name    = "${var.service_name}-${var.short_env}-public-${each.key}"
    Service = var.service_name
    ENV     = var.short_env
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.service_vpc.id

  tags = {
    Name    = "${var.service_name}-${var.short_env}-igw"
    Service = var.service_name
    ENV     = var.short_env
  }
}

resource "aws_route_table" "default" {
  vpc_id = aws_vpc.service_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name    = "${var.service_name}-${var.short_env}-default-routetable"
    Service = var.service_name
    ENV     = var.short_env
  }
}

resource "aws_route_table_association" "public" {
  for_each       = var.availability_zone
  route_table_id = aws_route_table.default.id
  subnet_id      = aws_subnet.public_subnet[each.key].id
}

resource "aws_subnet" "private_subnet" {
  for_each                = var.availability_zone
  cidr_block              = cidrsubnet(aws_vpc.service_vpc.cidr_block, 4, 2 + each.value)
  vpc_id                  = aws_vpc.service_vpc.id
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.service_name}-${var.short_env}-private-${each.key}"
    Service = var.service_name
    ENV     = var.short_env
  }
}
