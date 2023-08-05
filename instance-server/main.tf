terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.10.0"
    }
  }
}

provider "aws" {
    region = "eu-central-1"
}

resource "aws_instance" "amazon-vm-1" {
  ami           = "ami-0e00e602389e469a3"
  instance_type = "t2.micro"
  key_name      = "Cod_key_all_servers"
  count         = 2

  tags = {
    Name = "Amazon VM"
  }
}

resource "aws_instance" "ubuntu-vm-1" {
  ami           = "ami-0ab1a82de7ca5889c"
  instance_type = "t2.micro"
  key_name      = "Cod_key_all_servers"
  count         = 1

  tags = {
    Name = "Linux VM"
  }
}