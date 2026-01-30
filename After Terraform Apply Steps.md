# 🚀 After Terraform Apply (Manual Steps)

## SSH into the instance:
```
ssh -i linuxxx.pem ubuntu@<PUBLIC_IP>
```


## Start Minikube:
```
minikube start
```

## Verify:
```
minikube status
kubectl get nodes
```

## 🧠 Why this version is CORRECT (Interview-ready)

Docker driver is explicitly configured

No deprecated CRI plumbing

ARM-compatible binaries

Minikube started by user, not cloud-init (avoids race conditions)

Matches 2025+ Minikube best practices

🔍 If interviewer asks:

“How does Minikube run on EC2?”