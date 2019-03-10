#!/bin/bash

# For example PROVISION_MASTER_SSH=user@masterhost
: ${PROVISION_MASTER_SSH:?"Need to set PROVISION_MASTER_SSH non-empty"}

# Get the version of docker and kubernetes binaries from the master
ssh $PROVISION_MASTER_SSH "dpkg-query --showformat='\${Version}' --show docker-ce && dpkg-query --showformat='\${Version}' --show kubeadm"

declare RESULT=($(dpkg-query --showformat='${Version}' --show docker-ce 
 && printf "\n" 
 && dpkg-query --showformat='${Version}' --show kubeadm))
echo "First line: ${RESULT[0]}"
echo "Second line: ${RESULT[1]}"
echo "N-th line: ${RESULT[N]}"

# # Run init
# wget --no-cache -O - https://raw.githubusercontent.com/jonaskello/metal-kube/master/provision/init-node.sh | bash

# # SSH to the master to get the join commnad
# ssh $PROVISION_MASTER_SSH "kubeadm token create --print-join-command --ttl=1h0m0s"

# # In order to run kubectl the user needs access
# mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config
