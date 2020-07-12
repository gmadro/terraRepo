provider "aws" {
  region = "us-east-1"
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
    ami = var.image_name
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