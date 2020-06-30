provider "aws" {
  region = "us-east-1"
}

terraform {
    backend "s3" {
        bucket = "terrapipeline16-terraformstatestore-14b2ipf5nfhta"
        key = "terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "terrapipeline16-lockdb"
    }
}

resource "aws_instance" "remote"{
    ami = "ami-09d95fab7fff3776c"
    instance_type = "t2.micro"

    tags = {
        Name = "CF-Pipeline-Build"
    }
}