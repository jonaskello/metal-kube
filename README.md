# metal-kube

Provisioning scripts for bare-metal kubernets using kubeadm.

These scripts are designed to work on fresh installs of Ubuntu 16.04.

## Provision the first master node

This script takes two parameters:

1. Docker version to install.
2. URL for a cluster-config.yml file.

It will install the version of docker specified by the firest parameter, and the version of kubernetes binaries specified in the cluster-config.yml file.

```bash
# Init the first master with docker version 18.06.1~ce~3-0~ubuntu, specified cluster-config.yaml, and Canal network add-on
curl -fsSL https://raw.githubusercontent.com/jonaskello/metal-kube/master/first-master.sh | bash -s -- 18.06.1~ce~3-0~ubuntu https://raw.githubusercontent.com/jonaskello/metal-kube/master/cluster-config.yaml
```

## Provision a worker node

This script requires no parameters. It shuold be run on a master node. It will generate a bash command that should be run on the worker node in order to install docker, kubernetes binaries (same vesion as the master node) and join the node to the cluster.

```bash
# Run this on a master node to generate a worker provisioning command, then run the generated command on the worker to provision it
curl -fsSL https://raw.githubusercontent.com/jonaskello/metal-kube/master/worker-gen.sh | bash
```

Alternatively, if the worker has ssh access to the master you can run it on the worker:

```bash
ssh myuser@mymaster "curl -fsSL https://raw.githubusercontent.com/jonaskello/metal-kube/master/worker-gen.sh | bash" | bash
```

## Provision additional master nodes

```bash
ssh myuser@mymaster "curl -fsSL https://raw.githubusercontent.com/jonaskello/metal-kube/master/add-master-get.sh | bash" | bash
```

Copy the certificate files from the first control plane node to the rest:

In the following example, replace CONTROL_PLANE_IPS with the IP addresses of the other control plane nodes.

USER=ubuntu # customizable
CONTROL_PLANE_IPS="10.0.0.7 10.0.0.8"
for host in ${CONTROL_PLANE_IPS}; do
    scp /etc/kubernetes/pki/ca.crt "${USER}"@$host:/etc/kubernetes/pki/
    scp /etc/kubernetes/pki/ca.key "${USER}"@$host:/etc/kubernetes/pki/
    scp /etc/kubernetes/pki/sa.key "${USER}"@$host:/etc/kubernetes/pki/
    scp /etc/kubernetes/pki/sa.pub "${USER}"@$host:/etc/kubernetes/pki/
    scp /etc/kubernetes/pki/front-proxy-ca.crt "${USER}"@$host:/etc/kubernetes/pki/
    scp /etc/kubernetes/pki/front-proxy-ca.key "${USER}"@$host:/etc/kubernetes/pki/
    scp /etc/kubernetes/pki/etcd/ca.crt "${USER}"@$host:/etc/kubernetes/pki/etcd/
    scp /etc/kubernetes/pki/etcd/ca.key "${USER}"@$host:/etc/kubernetes/pki/etcd/
    scp /etc/kubernetes/admin.conf "${USER}"@\$host:/etc/kubernetes/
done

Move the files created by the previous step where scp was used:

USER=ubuntu # customizable
mkdir -p /etc/kubernetes/pki/etcd
mv /home/${USER}/ca.crt /etc/kubernetes/pki/
mv /home/${USER}/ca.key /etc/kubernetes/pki/
mv /home/${USER}/sa.pub /etc/kubernetes/pki/
mv /home/${USER}/sa.key /etc/kubernetes/pki/
mv /home/${USER}/front-proxy-ca.crt /etc/kubernetes/pki/
mv /home/${USER}/front-proxy-ca.key /etc/kubernetes/pki/
mv /home/${USER}/etcd-ca.crt /etc/kubernetes/pki/etcd/ca.crt
mv /home/${USER}/etcd-ca.key /etc/kubernetes/pki/etcd/ca.key
mv /home/\${USER}/admin.conf /etc/kubernetes/admin.conf

sudo kubeadm join 192.168.0.200:6443 --token j04n3m.octy8zely83cy2ts --discovery-token-ca-cert-hash sha256:84938d2a22203a8e56a787ec0c6ddad7bc7dbd52ebabc62fd5f4dbea72b14d1f --experimental-control-plane

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
