#!/bin/bash

# Set options to fail properly
exec 4>&1
BASH_XTRACEFD=4
set -Eeuxo pipefail
export SHELLOPTS

# For example PROVISION_MASTER_SSH=user@masterhost
: ${MK_MASTER_SSH:?"Need to set MK_MASTER_SSH non-empty, eg. user@my-master-hostname"}

# Get the version of docker, kubernetes binaries, and the join command from the master
readarray -t MASTER_INFO < <(ssh $MK_MASTER_SSH "dpkg-query --showformat='\${Version}' --show docker-ce && echo && dpkg-query --showformat='\${Version}' --show kubeadm && echo && kubeadm token create --print-join-command --ttl=1h0m0s")
export MK_DOCKER=${MASTER_INFO[0]}
export MK_KUBE=${MASTER_INFO[1]}
export MK_JOIN=${MASTER_INFO[2]}

echo "MK_DOCKER: $MK_DOCKER"
echo "MK_KUBE: $MK_KUBE"
echo "MK_JOIN: $MK_JOIN"

# Run init
wget -nv --no-cache -O - https://raw.githubusercontent.com/jonaskello/metal-kube/master/init-node.sh | bash

# Run join
eval $MK_JOIN
