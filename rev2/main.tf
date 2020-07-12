provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "packer" {
  owners = ["self"]

  filter {
    name = "name"
    values = var.image_name
  }
}

terraform {
    backend "s3" {
        bucket = "handled-by-pipline"
        key = "terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "handled-by-pipline"
    }
}

resource "aws_instance" "remote"{
    ami = data.aws_ami.packer.id
    instance_type = "t2.micro"
    key_name = "ACGwork"

    tags = {
        Name = var.image_name
    }
}

output "instance_ip_addr" {
  value       = aws_instance.remote.private_ip
  description = "The private IP address of the main server instance."
}