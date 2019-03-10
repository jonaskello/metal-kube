#!/bin/bash

set -x

# This script install the version of docker specified by $PROVISION_DOCKER_VERSION
# This scripts installs the version of kubelet, kubeadm, kubectl specified in $PROVISION_KUBE_VERSION

: ${MK_DOCKER:?"Need to set MK_DOCKER_VERSION non-empty"}
: ${MK_KUBE:?"Need to set MK_KUBE_VERSION non-empty"}

### DOCKER

# Add docker repos
sudo apt-get update
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update

# Install specific version of docker
sudo apt-get install -y docker-ce=$MK_DOCKER
apt-mark hold docker-ce

# Give user rights to run docker
sudo usermod -aG docker $USER

#### KUBE

# Remove swap
sudo swapoff -a
#vi /etc/fstab # Remove swap in this file
sudo sed -i.bak '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Add repos for kubelet, kubeadm, kubectl
sudo apt-get update
sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update

# Install kubelet, kubeadm, kubectl
sudo apt-get install -y kubelet=$MK_KUBE kubectl=$MK_KUBE kubeadm=$MK_KUBE
sudo apt-mark hold kubelet kubeadm kubectl
