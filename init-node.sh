#!/bin/bash

# This script install the version of docker specified by $1
# This scripts installs the version of kubelet, kubeadm, kubectl specified in $2

# Set options to fail properly
exec 4>&1
BASH_XTRACEFD=4
set -Eeuxo pipefail
export SHELLOPTS

# Verify arguments
if [ -z "$1" ]
  then
    echo "The argument for docker version was not supplied."
fi
MK_DOCKER=$1
if [ -z "$2" ]
  then
    echo "The argument for kubernetes binaries version was not supplied."
fi
MK_KUBE=$2


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
sudo apt-mark hold docker-ce

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
