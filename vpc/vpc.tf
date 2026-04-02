#version block
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.4.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "ap-south-1"
}

# create vpc
resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
  
}



### PUBLIC SUBNET ###
# create public subnet
resource "aws_subnet" "my-public-subnet" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-public-subnet"
  }
}

# create internet gateway
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "my-igw"
  }
}


# create route table
resource "aws_route_table" "my-route-table" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "my-route-table"
  }
}

# in route table a route has 2 things destination and target. destination is where we want to go and target is how we want to reach there. 
#In this case we want to reach internet and to reach internet we need to use internet gateway. So destination is 0.0.0/0 and target is internet gateway.

# create route to internet gateway
resource "aws_route" "my-route" {
  route_table_id = aws_route_table.my-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my-igw.id
}

# associate route table with public subnet
resource "aws_route_table_association" "my-route-table-association" {
  subnet_id = aws_subnet.my-public-subnet.id
  route_table_id = aws_route_table.my-route-table.id
} 



## PRIVATE SUBNET ###
# create private subnet
resource "aws_subnet" "my-private-subnet" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "my-private-subnet"
  }
} 

