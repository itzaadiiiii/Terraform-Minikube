# Terraform-Minikube setup

### 1 Install terraform 
```
terraform-install.sh
chmod +x terraform-install.sh
./terraform-install.sh
```
## OR 
```
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update

sudo apt-get install terraform

terraform version

touch ~/.bashrc

terraform -install-autocomplete

exec "$SHELL"
```

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
```
sudo apt update && sudo apt install snapd. 
sudo snap install kubectl --classic
```

### 3 Check minikube status
> minikube status

### 4 Start miniikube cluster
> minikube start --driver=docker

### 5 Varify Cluster is Running
> kubectl get nodes
