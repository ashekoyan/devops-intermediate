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
    #function
    user_data = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
echo "<h1>Barev Gazanik jan$(hostname -f)</h1>" > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
EOF

  tags = {
    Name = "Amazon VM"
    Owner = "Areg Shekoyan"
  }
  vpc_security_group_ids = [aws_security_group.amazon-sg.id]
}

resource "aws_security_group" "amazon-sg" {
  name        = "wb-sg"
  description = "terraform SG"

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}