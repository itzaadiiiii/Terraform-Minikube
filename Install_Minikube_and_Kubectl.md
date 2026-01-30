# Installing Minikube and kubectl on Ubuntu EC2

This document provides a complete setup guide for installing Minikube and kubectl on an Ubuntu EC2 instance, specifically optimized for t4g.small instances with Calico CNI.

---

## Environment Details
- **OS:** Ubuntu 20.04 / 22.04 / 24.04
- **Instance Type:** t4g.small (ARM) or t3.medium (x86)
- **Kubernetes:** Minikube
- **Container Runtime:** Docker
- **CNI:** Calico

---

## Step 0: Install Docker (Prerequisite)

Minikube needs a container runtime to manage the cluster nodes.

```bash
# Update system packages
sudo apt update -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt update -y
sudo apt install docker-ce -y

# Allow current user to run docker without sudo
sudo usermod -aG docker $USER && newgrp docker
```

---

## Step 1: Install kubectl

```bash
# Update system and install snap
sudo apt update && sudo apt install snapd -y

# Install kubectl via snap
sudo snap install kubectl --classic

# Verify installation
kubectl version --client
```

---

## Step 2: Install Minikube("Already Installed Via terraform you can skip")

```bash
# Download the latest Minikube binary
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-$(dpkg --print-architecture)

# Install Minikube
sudo install minikube-linux-$(dpkg --print-architecture) /usr/local/bin/minikube

# Verify installation
minikube version
```

---

## Step 3: Start Minikube Cluster

⚠️ **Important:** Do NOT use `--driver=none` on EC2. Use the Docker driver for better stability.

```bash
# Start Minikube with Docker driver and Calico CNI
minikube start \
  --driver=docker \
  --network-plugin=cni \
  --cni=calico \
  --cpus=2 \
  --memory=2048
```

⚠️ **Troubleshooting:** If Minikube was previously started and is causing issues, clean the state first:
```bash
minikube delete
rm -rf ~/.minikube
```

---
## Step 3: Start Minikube Cluster

⚠️ **Important:** Do NOT use `--driver=none` on EC2. Use the Docker driver for better stability.

```bash
# Start Minikube with Docker driver and Calico CNI
minikube start \
  --driver=docker \
  --network-plugin=cni \
  --cni=calico \
  --cpus=2 \
  --memory=2048
```
---

## Step 4: Fix Permissions

Ensure your user owns the configuration directories to avoid using sudo for every command.

```bash
# Move and change ownership of kube and minikube directories
sudo mv /home/ubuntu/.kube /home/ubuntu/.minikube $HOME 2>/dev/null || true
sudo chown -R $USER $HOME/.kube $HOME/.minikube
```

---

## Step 5: Verify Installation

```bash
# Check Minikube status
minikube status

# Check cluster nodes
kubectl get nodes

# Check Calico pods (Networking)
kubectl get pods -n kube-system | grep calico

# Verify cluster info
kubectl cluster-info
```

**Expected Status Output:**
```
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
```

---

## Step 6: Install Essential Add-ons

```bash
# Install Helm (package manager)
sudo snap install helm --classic

# Enable Metrics Server (for kubectl top nodes/pods)
minikube addons enable metrics-server

# Enable Ingress Controller (Nginx)
minikube addons enable ingress

# Verify add-ons
minikube addons list
```

---

## Step 7: Test Deployment

Create a test deployment to verify everything works:

```bash
# Create a sample nginx deployment
kubectl create deployment test-app --image=nginx

# Expose the deployment
kubectl expose deployment test-app --name=test-app-svc --type=NodePort --port=80

# Get the service URL
minikube service test-app-svc --url

# Clean up test deployment
kubectl delete deployment test-app
kubectl delete service test-app-svc
```

---

## Step 8: Management Commands

### Stop the cluster (to save costs)
```bash
minikube stop
```

### Start the cluster again
```bash
minikube start
```

### Delete everything to start fresh
```bash
minikube delete
rm -rf ~/.minikube
rm -rf ~/.kube
```

---

## Best Practices & Notes

- **Calico CNI:** Chosen for advanced Network Policies support, which the default Minikube network doesn't provide
- **ARM Instances:** For t4g (Graviton/ARM), ensure Docker images are multi-arch or built for ARM64
- **Security Groups:** Ensure EC2 Security Group allows SSH (22). For NodePort services, open ports 30000-32767
- **Resource Limits:** t4g.small has 2 vCPUs and 2GB RAM, which is sufficient for basic testing
- **Docker Driver:** More stable than none driver on EC2 instances

---

## Troubleshooting

### Common Issues:
1. **Permission denied errors:** Run the permission fix step (Step 4)
2. **Driver issues:** Always use `--driver=docker` on EC2
3. **Memory issues:** Increase memory with `--memory=4096` if needed
4. **Network issues:** Ensure Calico pods are running in `kube-system` namespace

### Debug Commands:
```bash
# Check Minikube logs
minikube logs

# Check pod status
kubectl get pods --all-namespaces

# Describe problematic pods
kubectl describe pod <pod-name> -n <namespace>
```

---

✅ **Minikube and kubectl setup completed successfully!**

You now have a fully functional Kubernetes cluster running on your Ubuntu EC2 instance, ready for deploying applications and testing Kubernetes workloads.
