// main.tf
// Terraform script to launch an EC2 instance in ap-south-1 with Minikube setup
// only change the region and key name accordingly

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.99.1"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

// Fetch the latest Ubuntu ARM64 AMI from Amazon
data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-arm64-server-*"]
  }
}

// Create an EC2 instance with user_data to install Minikube and Docker
resource "aws_instance" "terraform_test_ec2" {
  count         = 1
  instance_type = "t4g.small"
  ami           = data.aws_ami.server_ami.id
  key_name      = "linuxxx"

  tags = {
    Name = "terraform_ec2_minikube_${count.index}"
  }

  // user_data script to install Docker and Minikube
  user_data = <<-EOF
    #!/bin/bash
    apt-get update && apt-get install -y docker.io net-tools vim conntrack containernetworking-plugins

    # Install Minikube
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm64
    install minikube-linux-arm64 minikube
    chmod +x minikube && mv minikube /usr/local/bin/

    # Install crictl
    VERSION="v1.26.1"
    wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-arm64.tar.gz
    tar zxvf crictl-$VERSION-linux-arm64.tar.gz -C /usr/local/bin
    rm -f crictl-$VERSION-linux-arm64.tar.gz

    # Install cri-dockerd
    VER=$(curl -s https://api.github.com/repos/Mirantis/cri-dockerd/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/v//g')
    wget https://github.com/Mirantis/cri-dockerd/releases/download/v$VER/cri-dockerd-$VER.arm64.tgz
    tar xvf cri-dockerd-$VER.arm64.tgz
    mv cri-dockerd/cri-dockerd /usr/local/bin/

    # Set up systemd services
    wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.service
    wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.socket
    mv cri-docker.socket cri-docker.service /etc/systemd/system/
    sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
    systemctl daemon-reload
    systemctl enable cri-docker.service
    systemctl enable --now cri-docker.socket

    # Configure Minikube
    minikube config set memory 1800
    usermod -a -G docker ubuntu
  EOF

  // Uncomment and define if using security groups
  // vpc_security_group_ids = [aws_security_group.terraform_test_sg.id]
}

output "instance_public_ip" {
  value = aws_instance.terraform_test_ec2[0].public_ip
}
