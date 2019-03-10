#!/bin/bash

# This script install the version of docker specified by $PROVISION_DOCKER_VERSION
# This scripts installs the version of kubelet, kubeadm, kubectl specified in $PROVISION_KUBE_VERSION

### DOCKER

# Add docker repos
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update

# Install specific version of docker
sudo apt-get install docker-ce=$PROVISION_DOCKER_VERSION
apt-mark hold docker-ce

# Give user rights to run docker
sudo usermod -aG docker $USER

#### KUBE

# Remove swap
sudo swapoff -a
#vi /etc/fstab # Remove swap in this file
sudo sed -i.bak '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Add repos for kubelet, kubeadm, kubectl
sudo apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sudo cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update

# Install kubelet, kubeadm, kubectl
sudo apt-get install -y kubelet=$PROVISION_KUBE_VERSION kubectl=$PROVISION_KUBE_VERSION kubeadm=$PROVISION_KUBE_VERSION
sudo apt-mark hold kubelet kubeadm kubectl
