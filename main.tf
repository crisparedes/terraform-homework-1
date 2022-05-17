terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider

provider "aws" {
  region = "us-west-2"
}

# Create a VPC

resource "aws_vpc" "vpc-CristianParedesTF" {
  cidr_block = "34.0.0.0/16"
   tags = {
      Name = "vpc-CristianParedesTF"
    }
}

#Create Internet Gateway

resource "aws_internet_gateway" "igw-CristianParedesTF" {
  vpc_id = aws_vpc.vpc-CristianParedesTF.id

  tags = {
    Name = "igw-CristianParedesTF"
  }
}

#Create Elastic Ip Adress fot the NAT Gateway
resource "aws_eip" "aip-CristianParedesTF"{
 vpc= true
 depends_on = [aws_internet_gateway.igw-CristianParedesTF]
 }   

#Create NAT Gateway

resource "aws_nat_gateway" "nat-CristianParedesTF" {
    allocation_id= aws_eip.aip-CristianParedesTF.id
  subnet_id     = aws_subnet.public1-subnet-CristianParedesTF.id
   depends_on = [aws_internet_gateway.igw-CristianParedesTF]
  tags = {
    Name = "nat-CristianParedesTF"
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
 
}

# Create public Subnets

resource "aws_subnet" "public1-subnet-CristianParedesTF" {
  vpc_id     = aws_vpc.vpc-CristianParedesTF.id
  cidr_block = "34.0.1.0/24"
  availability_zone ="us-west-2a"
  tags = {
    Name = "public1-subnet-CristianParedesTF"
  }
}

resource "aws_subnet" "public2-subnet-CristianParedesTF" {
  vpc_id     = aws_vpc.vpc-CristianParedesTF.id
  cidr_block = "34.0.2.0/24"
  availability_zone ="us-west-2b"
  tags = {
    Name = "public2-subnet-CristianParedesTF"
  }
}

resource "aws_subnet" "public3-subnet-CristianParedesTF" {
  vpc_id     = aws_vpc.vpc-CristianParedesTF.id
  cidr_block = "34.0.3.0/24"
  availability_zone ="us-west-2c"
  tags = {
    Name = "public3-subnet-CristianParedesTF"
  }
}

# Create private Subnets

resource "aws_subnet" "private1-subnet-CristianParedesTF" {
  vpc_id     = aws_vpc.vpc-CristianParedesTF.id
  cidr_block = "34.0.4.0/24"
  availability_zone ="us-west-2a"
  tags = {
    Name = "private1-subnet-CristianParedesTF"
  }
}

resource "aws_subnet" "private2-subnet-CristianParedesTF" {
  vpc_id     = aws_vpc.vpc-CristianParedesTF.id
  cidr_block = "34.0.5.0/24"
  availability_zone ="us-west-2b"
  tags = {
    Name = "private2-subnet-CristianParedesTF"
  }
}

resource "aws_subnet" "private3-subnet-CristianParedesTF" {
  vpc_id     = aws_vpc.vpc-CristianParedesTF.id
  cidr_block = "34.0.6.0/24"
  availability_zone ="us-west-2c"
  tags = {
    Name = "private3-subnet-CristianParedesTF"
  }
}

#Public Route Table

resource "aws_route_table" "rt-public-CristianParedesTF" {
  vpc_id = aws_vpc.vpc-CristianParedesTF.id

    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-CristianParedesTF.id
  }

  tags = {
    Name = "rt-public-CristianParedesTF"
  }
}

#private Route Table

resource "aws_route_table" "rt-private-CristianParedesTF" {
  vpc_id = aws_vpc.vpc-CristianParedesTF.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-CristianParedesTF.id
  }

  tags = {
    Name = "rt-private-CristianParedesTF"
  }
}

#Route table public associations

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public1-subnet-CristianParedesTF.id
  route_table_id = aws_route_table.rt-public-CristianParedesTF.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public2-subnet-CristianParedesTF.id
  route_table_id = aws_route_table.rt-public-CristianParedesTF.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.public3-subnet-CristianParedesTF.id
  route_table_id = aws_route_table.rt-public-CristianParedesTF.id
}


#Route table private associations

resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.private1-subnet-CristianParedesTF.id
  route_table_id = aws_route_table.rt-private-CristianParedesTF.id
}

resource "aws_route_table_association" "e" {
  subnet_id      = aws_subnet.private2-subnet-CristianParedesTF.id
  route_table_id = aws_route_table.rt-private-CristianParedesTF.id
}

resource "aws_route_table_association" "f" {
  subnet_id      = aws_subnet.private3-subnet-CristianParedesTF.id
  route_table_id = aws_route_table.rt-private-CristianParedesTF.id
}