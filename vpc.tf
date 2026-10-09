# VPC
resource "aws_vpc" "demo" {
  cidr_block       = "11.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "learnvpc"
  }
}

# Public Subnet 1
resource "aws_subnet" "pub-sub" {
  vpc_id                  = aws_vpc.demo.id
  cidr_block              = "11.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }
}

# Public Subnet 2
resource "aws_subnet" "pub-sub-2" {
  vpc_id                  = aws_vpc.demo.id
  cidr_block              = "11.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.demo.id

  tags = {
    Name = "learnIGW"
  }
}

# Public Route Table
resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "learn-RT"
  }
}

# Route Table Association - Subnet 1
resource "aws_route_table_association" "public-subnet-1" {
  subnet_id      = aws_subnet.pub-sub.id
  route_table_id = aws_route_table.route-table.id
}

# Route Table Association - Subnet 2
resource "aws_route_table_association" "public-subnet-2" {
  subnet_id      = aws_subnet.pub-sub-2.id
  route_table_id = aws_route_table.route-table.id
}