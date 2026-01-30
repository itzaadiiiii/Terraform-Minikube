# minikube cluster start once t4g.small ec2 instance is started

# Install kubectl
sudo apt update && sudo apt install snapd -y
sudo snap install kubectl --classic

#Start Minikube cluster and if already run command and giving issue the delete .minikube folder and run below minikube start command again and use --driver=docker not none orelse doesnt work

minikube start --driver=driver --network-plugin=cni --cni=calico

# To use kubectl or minikube commands as your own user, you may need to relocate them. For example, to overwrite your own settings, run:

sudo mv /home/ubuntu/.kube /home/ubuntu/.minikube $HOME
sudo chown -R $USER $HOME/.kube $HOME/.minikube
kubectl version
minikube version
minikube status
To ensure you have a truly complete and "zero-to-hero" file for your GitHub repository, I have included the Docker installation (Step 0) and the Add-ons (Helm/Ingress) as promised.

📄 File Name
minikube-complete-setup-ubuntu-ec2-calico.md

Markdown

# Minikube Kubernetes Complete Setup on Ubuntu EC2 (t4g.small)

This document provides a **complete end-to-end setup** for a Kubernetes environment on an AWS EC2 instance. It covers everything from Docker installation to starting a Minikube cluster with Calico CNI and installing essential tools like Helm.

---

## Environment Details
- **OS:** Ubuntu 20.04 / 22.04 / 24.04
- **Instance Type:** t4g.small (ARM) or t3.medium (x86)
- **Kubernetes:** Minikube
- **Container Runtime:** Docker
- **CNI:** Calico

---

## Step 0: Install Docker (Prerequisite)
#Minikube needs a container runtime to manage the cluster nodes.

```bash
sudo apt update -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL [https://download.docker.com/linux/ubuntu/gpg](https://download.docker.com/linux/ubuntu/gpg) | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] [https://download.docker.com/linux/ubuntu](https://download.docker.com/linux/ubuntu) $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
sudo apt install docker-ce -y

# Allow ubuntu user to run docker without sudo
sudo usermod -aG docker $USER && newgrp docker
Step 1: Install kubectl & Minikube Binary
Bash

# Install kubectl via snap
sudo snap install kubectl --classic

# Download and Install Minikube
curl -LO [https://storage.googleapis.com/minikube/releases/latest/minikube-linux-$(dpkg](https://storage.googleapis.com/minikube/releases/latest/minikube-linux-$(dpkg) --print-architecture)
sudo install minikube-linux-$(dpkg --print-architecture) /usr/local/bin/minikube
Step 2: Start Minikube Cluster
⚠️ Warning: If Minikube was previously started and is causing issues, clean the state first: minikube delete.

❗ Note: Do NOT use --driver=none on EC2. Use the Docker driver for a more stable, containerized control plane.

Bash

minikube start \
  --driver=docker \
  --network-plugin=cni \
  --cni=calico \
  --cpus=2 \
  --memory=2048


  
Step 3: Fix kubectl & Minikube Permissions
Ensure your user owns the configuration directories so you don't have to use sudo for every command.

Bash

sudo chown -R $USER:$USER $HOME/.kube $HOME/.minikube
Step 4: Verify Installation & Health

Bash

# Check status
minikube status

# Check nodes
kubectl get nodes

# Check Calico pods (Networking)
kubectl get pods -n kube-system | grep calico


Step 5: Install Essential Add-ons (Helm & Metrics)
To make the cluster production-ready for testing:

Bash

# Install Helm
sudo snap install helm --classic

# Enable Metrics Server (for kubectl top nodes/pods)
minikube addons enable metrics-server

# Enable Ingress Controller (Nginx)
minikube addons enable ingress
Step 6: Cleanup
Use these when you want to stop or completely wipe the cluster.

Bash

# Stop the instance to save costs
minikube stop

# Delete everything to start fresh
minikube delete
rm -rf ~/.minikube
rm -rf ~/.kube
Best Practices & Notes
Calico CNI: Chosen here because it supports advanced Network Policies (security rules), whereas the default Minikube network does not.

T4g Instances: Since you are using ARM (Graviton), ensure your Docker images are multi-arch or built for ARM64.

Security Groups: Ensure your EC2 Security Group allows SSH (22). If using NodePort services, you may need to open ports 30000-32767.

✅ Minikube Kubernetes cluster setup completed successfully!