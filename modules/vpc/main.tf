# --------------------
# VPC
# --------------------
resource "aws_vpc" "this" {
  cidr_block           = "172.16.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = var.name }
}

# --------------------
# Internet Gateway
# --------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${var.name}-igw" }
}

# --------------------
# Subnets (서울 리전: ap-northeast-2a, ap-northeast-2c)
# --------------------

# Public Bastion
resource "aws_subnet" "public_bastion" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "172.16.0.0/28"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = { Name = "public-bastion" }
}

# Public 2 (ALB용)
resource "aws_subnet" "public_az2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "172.16.0.48/28"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = { Name = "public-az2" }
}

# Private Web AZ1
resource "aws_subnet" "private_web_az1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "172.16.0.16/28"
  availability_zone = "ap-northeast-2a"

  tags = { Name = "private-web-az1" }
}

# Private Web AZ2
resource "aws_subnet" "private_web_az2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "172.16.0.80/28"
  availability_zone = "ap-northeast-2c"

  tags = { Name = "private-web-az2" }
}

# Private DB AZ1
resource "aws_subnet" "private_db_az1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "172.16.0.32/28"
  availability_zone = "ap-northeast-2a"

  tags = { Name = "private-db-az1" }
}

# Private DB AZ2
resource "aws_subnet" "private_db_az2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "172.16.0.96/28"
  availability_zone = "ap-northeast-2c"

  tags = { Name = "private-db-az2" }
}

# ------------------------
# NAT Gateway
# ------------------------
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags   = { Name = "${var.name}-nat-eip" }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_bastion.id

  tags = { Name = "${var.name}-nat" }
}

# ------------------------
# Route Tables
# ------------------------

# Public Route Table (IGW)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "public-route" }
}

# Public Associations
resource "aws_route_table_association" "public_bastion_assoc" {
  subnet_id      = aws_subnet.public_bastion.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_az2_assoc" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public.id
}

# Private Route Table (NAT)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = { Name = "private-route" }
}

# Private Associations (Web + DB)
resource "aws_route_table_association" "private_web_az1" {
  subnet_id      = aws_subnet.private_web_az1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_web_az2" {
  subnet_id      = aws_subnet.private_web_az2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db_az1" {
  subnet_id      = aws_subnet.private_db_az1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db_az2" {
  subnet_id      = aws_subnet.private_db_az2.id
  route_table_id = aws_route_table.private.id
}

