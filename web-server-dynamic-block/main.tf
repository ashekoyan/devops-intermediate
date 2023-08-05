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
  count         = 1
  
    // user_data   = file ("user_data.sh")
    user_data     = templatefile("user_data.tpl", {
      first_name  = "Areg",
      last_name   = "Shekoyan",
      names       = ["Taron", "Arthur", "Sargis", "Hovhannes", "Sergey"] 
    })

  tags = {
    Name = "Amazon VM"
    Owner = "Areg Shekoyan"
  }
  vpc_security_group_ids = [aws_security_group.amazon-sg.id]
}

resource "aws_security_group" "amazon-sg" {
  name        = "wb-sg"
  description = "terraform SG"

  dynamic "ingress" {
    for_each = ["443", "22", "80", "8585"]
    content {
      from_port = ingress.value
      to_port =  ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  # ingress {
  #   description = "TLS from VPC"
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # ingress {
  #   description = "TLS from VPC"
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # ingress {
  #   description = "TLS from VPC"
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}