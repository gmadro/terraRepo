provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "packer" {
  owners = ["self"]

  filter {
    name = "name"
    values = [var.image_name]
  }
}

data "aws_vpc" "default" {
  default = true
}

terraform {
    backend "s3" {
        bucket = "handled-by-pipline"
        key = "terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "handled-by-pipline"
    }
}

resource "aws_security_group" "allow_http_ssh" {
  name = "${var.image_name}-allow_http_ssh"
  description = " Allow HTTP and SSH traffic to this instance from ANYWHERE"
  vpc_id = data.aws_vpc.default.id

  ingress {
    description = "Custom HTTP from WORLD"
    from_port = 8080
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom SSH from WORLD"
    from_port = 2022
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow HTTP/SHH"
  }
}

resource "aws_instance" "remote"{
    ami = data.aws_ami.packer.id
    instance_type = "t2.micro"
    key_name = "ACGwork"

    tags = {
        Name = var.image_name
    }
    vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]
}

output "instance_ip_addr" {
  value       = aws_instance.remote.private_ip
  description = "The private IP address of the main server instance."
}