# Terraform-Minikube setup

### 1 Install terraform 
>> terraform-install.sh
>> chmod +x terraform-install.sh
>> ./terraform-install.sh

### 2 configure AWS-CLI
> aws configure      # put access key secret key or create role and attach to ec2 instance

### 3  Git Clone Repo
> git clone https://github.com/itzaadiiiii/Terraform-Minikube.git

> cd Terraform-Minikube
create or copy the key file to Terraform-Minikube folder as we require it for t4g.small instance to be getting created via terraform

> terraform init

> terraform fmt

> terraform validate

> terraform validate

> terraform plan

> terraform apply

### 4 Varify t4g.small instance created in aws EC2 inside which we have minikube cluster configured via terraform

### 1 ssh to minikube instance
> ssh -i <key-path> <user>@<ip-of-instance>

### 2 Install Kubectl on minikube instance

### 3 Check minikube status
> minikube status

### 4 Start miniikube cluster
> minikube start --driver=docker

### 5 Varify Cluster is Running
> kubectl get nodes
