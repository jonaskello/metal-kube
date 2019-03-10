#!/bin/bash

# This scripts installs the version of kubelet, kubeadm, kubectl specified in $PROVISION_KUBE_VERSION

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
