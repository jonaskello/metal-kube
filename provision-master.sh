#!/bin/bash

set -x

# Run init
wget --no-cache -O - https://raw.githubusercontent.com/jonaskello/metal-kube/master/init-node.sh | bash

# Init the master using param for Canal network add-on
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# In order to run kubectl the user needs access
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Canal pod network add-on
kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/canal/rbac.yaml
kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/canal/canal.yaml
