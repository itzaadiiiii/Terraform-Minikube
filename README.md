# Terraform-Minikube setup
### 1 Install terraform 
### 2 confihure AWS-CLI
### 3  Git Clone Repo
> git clone https://github.com/itzaadiiiii/Terraform-Minikube.git
> cd Terraform-Minikube
> terraform validate
> terraform fmt
> terraform validate
> terraform plan
> terraform apply
### 4 Varify t4g.small instance created in aws EC2 inside which we have minikube cluster configured via terraform

### 1 ssh to minikube instance
### 2 Install Kubectl on minikube instance
### 3 Check minikube status
> minikube status
### 4 Start miniikube cluster
> minikube start --driver=docker
### 5 Varify Cluster is Running
> kubectl get nodes
