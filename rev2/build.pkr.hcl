variable "image_name" {
  type = string
  description = "Name of image"
  default = "handled-by-pipline"
}

source "amazon-ebs" "build1" {
  ami_name = "hardcode-test"
  region = "us-east-1"
  instance_type = "t2.micro"
  source_ami = "ami-08f3d892de259504d"

  ssh_username = "ec2-user"
}

build {
    sources = [
        "source.amazon-ebs.build1"
    ]

    provisioner "shell" {
        inline = [
            "sudo yum install -y docker"
        ]
    }
}

