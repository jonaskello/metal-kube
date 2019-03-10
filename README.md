# metal-kube

Provisioning scripts for bare-metal kubernets using kubeadm.

These scripts are designed to work on fresh installs of Ubuntu 16.04.

## Provision the first master node

Determine which version you want of docker and kubernetes binaries and set them in env. Then run the script.

```bash
# Set the versions in env
export PROVISION_DOCKER_VERSION=18.06.1~ce~3-0~ubuntu
export PROVISION_KUBE_VERSION=1.13.4-00

# Init the first master with Canal network add-on
wget --no-cache -O - https://raw.githubusercontent.com/jonaskello/metal-kube/master/provision-master.sh | bash
```

## Provision a worker node

This script will get the version of docker and kubernetes binaries from the master, and install the same on the worker. It will also get the kubeadm join command from the master and run it.

```bash
# Set the SSH info for the master
export MK_MASTER_SSH=myuser@mymaster

# Provision the worker node
wget --no-cache -O - https://raw.githubusercontent.com/jonaskello/metal-kube/master/provision-worker.sh | bash
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

## Init node

If you want to run kubeadm yourself, you can run the init script to just install docker and the kubernetes binaries. It will install docker and kubernetes binaries needed by all nodes, regardless of role (master, worker). Determine which version you want of docker and kubernetes binaries and set them in env. Then run the init script.

```bash
# Set the versions in env
export PROVISION_DOCKER_VERSION=18.06.1~ce~3-0~ubuntu
export PROVISION_KUBE_VERSION=1.13.4-00

# Init the node (this will install docker and the kubernetes binaries)
wget --no-cache -q -O - https://raw.githubusercontent.com/jonaskello/metal-kube/master/init-node.sh | bash
```

Now the node is initialized and you can provision it as a master or worker.
