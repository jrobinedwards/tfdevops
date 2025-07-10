resource "aws_vpc" "public-vpc" {
  cidr_block = "10.0.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support = true
  
  tags = {
    Name = "tf-deploy-vpc"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.public-vpc.id
  cidr_block = "10.0.0.0/28"
  availability_zone = "eu-west-2c"
  
  tags = {
    Name = "tf-deploy-public-subnet"
    Type = "public"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.public-vpc.id
  
  tags = {
    Name = "tf-deploy-igw"
  }
}

resource "aws_route_table" "default-routes" {
  vpc_id = aws_vpc.public-vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  
  tags = {
    Name = "tf-deploy-public-rt"
  }
}

resource "aws_route_table_association" "route-associations" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.default-routes.id
}


