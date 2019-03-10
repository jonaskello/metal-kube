# metal-kube

Provisioning scripts for bare-metal kubernets using kubeadm.

These scripts were designed to work on Ubuntu 16.04.

## Init node

This initialization needs to be run on all nodes. It will install docker and kubernetes binaries needed by all nodes, regardless of role (master, worker). Determine which version you want of docker and kubernetes binaries and set them in env. Then run the init script.

```bash
# Set the versions in env
export PROVISION_DOCKER_VERSION=18.06.1~ce~3-0~ubuntu
export PROVISION_KUBE_VERSION=1.13.4-00

# Init the node (this will install docker and the kubernetes binaries)
wget --no-cache -O - https://raw.githubusercontent.com/jonaskello/metal-kube/master/provision/init-node.sh | bash
```

Now the node is initialized and you can provision it as a master or worker.

## Provision first master node

Make sure the node is initialized first with the init script above, then run:

```bash
# Init the first master with Canal network add-on
wget --no-cache -O - https://raw.githubusercontent.com/jonaskello/metal-kube/master/provision/first-master-canal.sh | bash
```

## Provision a worker node

Make sure the node is initialized first with the init script above.

On a master node run this to get the join command:

```bash
kubeadm token create --print-join-command --ttl=1h0m0s
```

Then on the worker node run the command returned by the above script.

## How to find available versions of docker and kubernetes binaries

To find all versions of kubeadm, kubelet and kubectl (they use the same version number):

```bash
curl -s https://packages.cloud.google.com/apt/dists/kubernetes-xenial/main/binary-amd64/Packages | grep Version | awk '{print $2}'
```

To find all versions of docker-ce (only works after adding the docker apt-get repo):

```bash
apt-cache madison docker-ce
```
