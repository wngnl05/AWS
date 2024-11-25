resource "aws_vpc" "vpc" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true
    tags = {
        Name = "skills-vpc"
    }
}


resource "aws_subnet" "public-sub-a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-2a"

  tags = {
    Name = "skills-public-a",
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "public-sub-b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-2b"

  tags = {
    Name = "skills-public-b",
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "public-sub-c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-2c"

  tags = {
    Name = "skills-public-c",
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "private-sub-a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-northeast-2a"

  tags = {
    Name = "skills-private-a",
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "private-sub-b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "ap-northeast-2b"

  tags = {
    Name = "skills-private-b",
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "private-sub-c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.6.0/24"
  availability_zone       = "ap-northeast-2c"

  tags = {
    Name = "skills-private-c",
    "kubernetes.io/role/internal-elb" = 1
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = { Name = "skills-igw" }
}

resource "aws_eip" "eip-a" {
  domain = "vpc"
}
resource "aws_nat_gateway" "natgw-a" {
  allocation_id = aws_eip.eip-a.id
  subnet_id     = aws_subnet.public-sub-a.id
  tags = { Name = "skills-nat-a" }
}

resource "aws_eip" "eip-b" {
  domain = "vpc"
}
resource "aws_nat_gateway" "natgw-b" {
  allocation_id = aws_eip.eip-b.id
  subnet_id     = aws_subnet.public-sub-b.id
  tags = { Name = "skills-nat-b" }
}

resource "aws_eip" "eip-c" {
  domain = "vpc"
}
resource "aws_nat_gateway" "natgw-c" {
  allocation_id = aws_eip.eip-c.id
  subnet_id     = aws_subnet.public-sub-c.id
  tags = { Name = "skills-nat-c" }
}



resource "aws_route_table" "public-rt" {
  vpc_id                  = aws_vpc.vpc.id
  route {
    cidr_block            = "0.0.0.0/0"
    gateway_id            = aws_internet_gateway.igw.id
  }
  tags   = { Name = "skills-pub-rt" }
}

resource "aws_route_table" "private-a-rt" {
  vpc_id                  = aws_vpc.vpc.id
  route {
    cidr_block            = "0.0.0.0/0"
    gateway_id            = aws_nat_gateway.natgw-a.id
  }
  tags   = { Name = "skills-priv-a-rt" }
}

resource "aws_route_table" "private-b-rt" {
  vpc_id                  = aws_vpc.vpc.id
  route {
    cidr_block            = "0.0.0.0/0"
    gateway_id            = aws_nat_gateway.natgw-b.id
  }
  tags   = { Name = "skills-priv-b-rt" }
}

resource "aws_route_table" "private-c-rt" {
  vpc_id                  = aws_vpc.vpc.id
  route {
    cidr_block            = "0.0.0.0/0"
    gateway_id            = aws_nat_gateway.natgw-c.id
  }
  tags   = { Name = "skills-priv-c-rt" }
}


resource "aws_route_table_association" "public-a-join" {
  subnet_id      = aws_subnet.public-sub-a.id
  route_table_id = aws_route_table.public-rt.id
}
resource "aws_route_table_association" "public-b-join" {
  subnet_id      = aws_subnet.public-sub-b.id
  route_table_id = aws_route_table.public-rt.id
}
resource "aws_route_table_association" "public-c-join" {
  subnet_id      = aws_subnet.public-sub-c.id
  route_table_id = aws_route_table.public-rt.id
}
resource "aws_route_table_association" "private-a-join" {
  subnet_id      = aws_subnet.private-sub-a.id
  route_table_id = aws_route_table.private-a-rt.id
}
resource "aws_route_table_association" "private-b-join" {
  subnet_id      = aws_subnet.private-sub-b.id
  route_table_id = aws_route_table.private-b-rt.id
}
resource "aws_route_table_association" "private-c-join" {
  subnet_id      = aws_subnet.private-sub-c.id
  route_table_id = aws_route_table.private-c-rt.id
}
