# minikube cluster start onve t4g.small ec2 instance is started 

# Install kubectl
sudo apt update && sudo apt install snapd. 
sudo snap install kubectl --classic

#Start Minikube cluster and if already run command and giving issue the delete .minikube folder and run below minikube start command again and use --driver=docker not none orelse doesnt work

minikube start --driver=driver --network-plugin=cni --cni=calico

# To use kubectl or minikube commands as your own user, you may need to relocate them. For example, to overwrite your own settings, run:

sudo mv /home/ubuntu/.kube /home/ubuntu/.minikube $HOME
sudo chown -R $USER $HOME/.kube $HOME/.minikube
minikube status
kubectl version
