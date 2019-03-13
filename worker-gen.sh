#!/bin/bash

# This scripts needs to be run on a master node and will generate a command that should be run on the worker node to provision it.

# Set options to fail properly
exec 4>&1
BASH_XTRACEFD=4
set -Eeuo pipefail
export SHELLOPTS

# Get the version of docker, kubernetes binaries, and the join command
MK_DOCKER=$(dpkg-query --showformat='${Version}' --show docker-ce)
MK_KUBE=$(dpkg-query --showformat='${Version}' --show kubeadm)
MK_JOIN=$(kubeadm token create --print-join-command --ttl=1h0m0s)

# Generate the command
# echo "curl -fsSL https://raw.githubusercontent.com/jonaskello/metal-kube/master/worker-run.sh | bash -s -- $MK_DOCKER $MK_KUBE \"$MK_JOIN\""
echo "curl -fsSL https://raw.githubusercontent.com/jonaskello/metal-kube/master/init-node.sh | bash -s -- $MK_DOCKER $MK_KUBE && $MK_JOIN"
