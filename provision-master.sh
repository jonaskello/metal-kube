#!/bin/bash

# Set options to fail properly
exec 4>&1
BASH_XTRACEFD=4
set -Eeuxo pipefail
export SHELLOPTS

# Run init-node (pass through arguments which are docker version and k8s version)
curl -fsSL https://raw.githubusercontent.com/jonaskello/metal-kube/master/init-node.sh | bash -s -- $1 $2

# Init the master using the config file (it needs to specify podSubnet: "10.244.0.0/16" for Canal)
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT
curl -fsSL $3 -o $TMP_DIR/cluster-config.yaml
sudo kubeadm init --config=$TMP_DIR/cluster-config.yaml

# In order to run kubectl the user needs access
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Canal pod network add-on
kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/canal/rbac.yaml
kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/canal/canal.yaml
