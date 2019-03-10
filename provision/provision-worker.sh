#!/bin/bash

# For example PROVISION_MASTER_SSH=user@masterhost
: ${PROVISION_MASTER_SSH:?"Need to set PROVISION_MASTER_SSH non-empty"}

# Get the version of docker and kubernetes binaries from the master
ssh $PROVISION_MASTER_SSH "dpkg-query --showformat='\${Version}' --show docker-ce && dpkg-query --showformat='\${Version}' --show kubeadm"

# Get the version of docker, kubernetes binaries, and join command from the master
declare RESULT=($(dpkg-query --showformat='${Version}' --show docker-ce && echo && dpkg-query --showformat='${Version}' --show kubeadm && echo && kubeadm token create --print-join-command --ttl=1h0m0s))
MK_DOCKER_VERSION=${RESULT[0]}
MK_KUBE_VERSION=${RESULT[1]}
MK_JOIN_CMD=${RESULT[2]}

echo "MK_DOCKER_VERSION: $MK_DOCKER_VERSION"
echo "MK_KUBE_VERSION: $MK_KUBE_VERSION"
echo "MK_JOIN_CMD: $MK_JOIN_CMD"

# echo "First line: ${RESULT[0]}"
# echo "Second line: ${RESULT[1]}"
# echo "N-th line: ${RESULT[N]}"

# # Run init
# wget --no-cache -O - https://raw.githubusercontent.com/jonaskello/metal-kube/master/provision/init-node.sh | bash

# # SSH to the master to get the join commnad
# ssh $PROVISION_MASTER_SSH "kubeadm token create --print-join-command --ttl=1h0m0s"

# # In order to run kubectl the user needs access
# mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config
