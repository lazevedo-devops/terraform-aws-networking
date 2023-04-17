//Create VPC Resource
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_main_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.vpc_name}"
    terraformed = "true"
  }
}

//Create 3 Public and 3 Private Subnets
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public1_cidr
  map_public_ip_on_launch = true
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.vpc_name}-subnet-pub-1-a"
    terraformed = "true"
    type = "public"
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public2_cidr
  map_public_ip_on_launch = true
  availability_zone = "${var.region}b"

  tags = {
    Name = "${var.vpc_name}-subnet-pub-2-b"
    terraformed = "true"
    type = "public"
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_subnet" "public3" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public3_cidr
  map_public_ip_on_launch = true
  availability_zone = "${var.region}c"

  tags = {
    Name = "${var.vpc_name}-subnet-pub-3-c"
    terraformed = "true"
    type = "public"
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private1_cidr
  map_public_ip_on_launch = false
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.vpc_name}-subnet-priv-1-a"
    terraformed = "true"
    type = "private"
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private2_cidr
  map_public_ip_on_launch = false
  availability_zone = "${var.region}b"

  tags = {
    Name = "${var.vpc_name}-subnet-priv-2-b"
    terraformed = "true"
    type = "private"
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_subnet" "private3" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private3_cidr
  map_public_ip_on_launch = false
  availability_zone = "${var.region}c"

  tags = {
    Name = "${var.vpc_name}-subnet-priv-3-c"
    terraformed = "true"
    type = "private"
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

//Create Internet Gateway for Public subnets and 3 Nat Gateways for Private Subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-igw"
    terraformed = "true"
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_eip" "ngw_ip1" {
  vpc      = true
  tags = {
    terraformed = "true"
    Name = "${var.vpc_name}-eip-ngw1-a"
  }
  depends_on = [
    aws_vpc.vpc,
    aws_internet_gateway.igw
  ]
}

resource "aws_eip" "ngw_ip2" {
  vpc      = true
  tags = {
    terraformed = "true"
    Name = "${var.vpc_name}-eip-ngw2-b"
  }
  depends_on = [
    aws_vpc.vpc,
    aws_internet_gateway.igw
  ]
}

resource "aws_eip" "ngw_ip3" {
  vpc      = true
  tags = {
    terraformed = "true"
    Name = "${var.vpc_name}-eip-ngw3-c"
  }
  depends_on = [
    aws_vpc.vpc,
    aws_internet_gateway.igw
  ]
}

resource "aws_nat_gateway" "ngw1" {
  allocation_id = aws_eip.ngw_ip1.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "${var.vpc_name}-ngw1-a"
    terraformed = "true"
  }
  depends_on = [
    aws_vpc.vpc,
    aws_internet_gateway.igw,
    aws_eip.ngw_ip1
  ]
}

resource "aws_nat_gateway" "ngw2" {
  allocation_id = aws_eip.ngw_ip2.id
  subnet_id     = aws_subnet.public2.id

  tags = {
    Name = "${var.vpc_name}-ngw2-b"
    terraformed = "true"
  }
  depends_on = [
    aws_vpc.vpc,
    aws_internet_gateway.igw,
    aws_eip.ngw_ip2
  ]
}

resource "aws_nat_gateway" "ngw3" {
  allocation_id = aws_eip.ngw_ip3.id
  subnet_id     = aws_subnet.public3.id

  tags = {
    Name = "${var.vpc_name}-ngw3-c"
    terraformed = "true"
  }
  depends_on = [
    aws_vpc.vpc,
    aws_internet_gateway.igw,
    aws_eip.ngw_ip3
  ]
}

//Create Route Tables, 1 for Public subnets and 3 for Private Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.vpc_name}-public-rtb"
    terraformed = "true"
  }
  depends_on = [
    aws_vpc.vpc,
    aws_internet_gateway.igw
  ]
}

resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw1.id
  }
  tags = {
    Name = "${var.vpc_name}-private1-rtb"
    terraformed = "true"
  }
  depends_on = [
    aws_vpc.vpc,
    aws_internet_gateway.igw
  ]
}

resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw2.id
  }
  tags = {
    Name = "${var.vpc_name}-private2-rtb"
    terraformed = "true"
  }
  depends_on = [
    aws_vpc.vpc,
    aws_internet_gateway.igw
  ]
}

resource "aws_route_table" "private3" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw3.id
  }
  tags = {
    Name = "${var.vpc_name}-private3-rtb"
    terraformed = "true"
  }
  depends_on = [
    aws_vpc.vpc,
    aws_internet_gateway.igw
  ]
}

//Create Asssociations betweens Route Tables and Subnets
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public3" {
  subnet_id      = aws_subnet.public3.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private1.id
}
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private2.id
}
resource "aws_route_table_association" "private3" {
  subnet_id      = aws_subnet.private3.id
  route_table_id = aws_route_table.private3.id
}