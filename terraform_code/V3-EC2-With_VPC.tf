provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "demo-server" {
    ami = "ami-00385a401487aefa4"
    instance_type = "t2.micro"
    key_name = "dpp"
    vpc_security_group_ids = [aws_security_group.demo-sg.id]
    subnet_id = aws_subnet.dpp-public-subnet-01.id 

}

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "SSH Access"
  vpc_id = aws_vpc.dpp-vpc.id 
  
  ingress {
    description      = "SHH access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ssh-prot"

  }
}

resource "aws_vpc" "dpp-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "dpp-vpc"
  }
  
}

resource "aws_subnet" "dpp-public-subnet-01" {
  vpc_id = aws_vpc.dpp-vpc.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "dpp-public-subent-01"
  }
}

resource "aws_subnet" "dpp-public-subnet-02" {
  vpc_id = aws_vpc.dpp-vpc.id
  cidr_block = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "dpp-public-subent-02"
  }
}

resource "aws_internet_gateway" "dpp-igw" {
  vpc_id = aws_vpc.dpp-vpc.id 
  tags = {
    Name = "dpp-igw"
  } 
}

resource "aws_route_table" "dpp-public-rt" {
  vpc_id = aws_vpc.dpp-vpc.id 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dpp-igw.id 
  }
}

resource "aws_route_table_association" "dpp-rta-public-subnet-01" {
  subnet_id = aws_subnet.dpp-public-subnet-01.id
  route_table_id = aws_route_table.dpp-public-rt.id   
}

resource "aws_route_table_association" "dpp-rta-public-subnet-02" {
  subnet_id = aws_subnet.dpp-public-subnet-02.id 
  route_table_id = aws_route_table.dpp-public-rt.id   
}
