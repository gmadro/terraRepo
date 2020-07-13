variable "image_name" {
  type = string
  description = "Name of image"
  default = "handled-by-pipline"
}

source "amazon-ebs" "build1" {
  ami_name = "${var.image_name}"
  region = "us-east-1"
  instance_type = "t2.micro"
  source_ami = "ami-08f3d892de259504d"
  force_deregister = true
  force_delete_snapshot = true

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

    provisioner "file" {
        source = "./app/"
        destination = "/tmp"
    }

    provisioner "shell" {
        inline = [
            "sudo systemctl start docker"
        ]
    }

    provisioner "shell" {
        inline = [
            "sudo docker build /tmp -t vmadbro/apache:1.0"
        ]
    }

    provisioner "shell" {
        inline = [
            "sudo systemctl enable docker"
        ]
    }

    provisioner "shell" {
        inline = [
            "sudo docker run -d --name Apache --restart unless-stopped -p 80:80 vmadbro/apache:1.0"
        ]
    }
}

