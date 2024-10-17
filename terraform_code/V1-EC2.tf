provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "demo-server" {
    ami = "ami-00385a401487aefa4"
    instance_type = "t2.micro"
    key_name = "dpp"
}
