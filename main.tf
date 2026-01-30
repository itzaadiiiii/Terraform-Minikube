// Terraform script to launch an EC2 instance in ap-south-1 with Minikube setup
// only change the region and key name accordingly

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.27.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# Latest Ubuntu ARM64 AMI
data "aws_ami" "ubuntu_arm" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-arm64-server-*"]
  }
}

resource "aws_instance" "minikube_ec2" {
  instance_type = "t4g.small"
  ami           = data.aws_ami.ubuntu_arm.id
  key_name = "minikube-key.pem"


  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "ec2-minikube-arm"
  }

  user_data = <<-EOF
    #!/bin/bash
    set -eux

    # Update system
    apt-get update -y

    # Install Docker
    apt-get install -y docker.io conntrack

    systemctl enable docker
    systemctl start docker

    # Allow ubuntu user to run docker
    usermod -aG docker ubuntu

    # Install Minikube (latest ARM64)
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm64
    chmod +x minikube-linux-arm64
    mv minikube-linux-arm64 /usr/local/bin/minikube

    # Set Docker as default Minikube driver
    su - ubuntu -c "minikube config set driver docker"

    # Reduce memory footprint for t4g.small
    su - ubuntu -c "minikube config set memory 1800"
  EOF
}

output "instance_public_ip" {
  value = aws_instance.minikube_ec2.public_ip
}
