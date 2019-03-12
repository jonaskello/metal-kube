# metal-kube

Provisioning scripts for bare-metal kubernets using kubeadm.

These scripts are designed to work on fresh installs of Ubuntu 16.04.

## Provision the first master node

This script will install the specified versions of docker and kubernetes binaries. It will then run kubadm to init the node as a master, and install Canal network add-on. Determine which version you want of docker and kubernetes binaries and set them in env. Then run the script.

```bash
# Init the first master with docker version 18.06.1~ce~3-0~ubuntu, specified cluster-config.yaml, and Canal network add-on
curl -fsSL https://raw.githubusercontent.com/jonaskello/metal-kube/master/first-master.sh | bash -s -- 18.06.1~ce~3-0~ubuntu https://raw.githubusercontent.com/jonaskello/metal-kube/master/cluster-config.yaml
```

## Provision a worker node

This script shuold be run on a master node. It will generate a bash command that should be run on the worker node in order to install docker, kubernetes binaries and join the node to the cluster.

```bash
# Run this on a master node to generate a worker provisioning command, then run the generated command on the worker to provision it
curl -fsSL https://raw.githubusercontent.com/jonaskello/metal-kube/master/worker-gen.sh | bash
```

If the worker has ssh access to the master you can also run directly on the worker:

```bash
ssh myuser@mymaster "curl -fsSL https://raw.githubusercontent.com/jonaskello/metal-kube/master/provision-worker-gen.sh | bash" | bash
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

If you want to run kubeadm yourself, you can run the init script to just install docker and the kubernetes binaries. It will install docker and kubernetes binaries that are needed by all nodes, regardless of role (master, worker). Determine which version you want of docker and kubernetes binaries and add them as parameters at the end of the command.

```bash
# This will install docker version 18.06.1~ce~3-0~ubuntu and kubernetes binaries version 1.13.4-00
curl -fsSL https://raw.githubusercontent.com/jonaskello/metal-kube/master/init-node.sh | bash -s -- 18.06.1~ce~3-0~ubuntu 1.13.4-00
```
