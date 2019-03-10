# metal-kube

Provisioning scripts for bare-metal kubernets using kubeadm.

These scripts were designed to work on Ubuntu 16.04.

## How to Provision nodes

First install Ubuntu 16.04.

Next, determine which version you want of docker and kubernetes binaries and set them in env. Then run the provisioning script.

```bash
# Set the versions in env
export PROVISION_DOCKER_VERSION=18.06.1~ce~3-0~ubuntu
export PROVISION_KUBE_VERSION=1.13.4-00

# To provision a master node
wget --no-cache -O - https://raw.githubusercontent.com/jonaskello/metal-kube/master/provision/provision.sh | bash

# To provision a worker node
wget --no-cache -O - https://raw.githubusercontent.com/jonaskello/metal-kube/master/provision/provision-worker.sh | bash
```

## How to find available versions of docker and kubernetes binaries

To find all versions of kubeadm, kubelet and kubectl (they use the same version number):

```bash
curl -s https://packages.cloud.google.com/apt/dists/kubernetes-xenial/main/binary-amd64/Packages | grep Version | awk '{print $2}'
```

To find all versions of docker-ce (only works after adding the docker apt-get repo):

```bash
apt-cache madison docker-ce
```
