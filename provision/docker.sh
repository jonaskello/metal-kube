#!/bin/bash

# This script install the version of docker specified by $PROVISION_DOCKER_VERSION

# Add docker repos
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update

# Install specific version of docker
sudo apt-get install docker-ce=$PROVISION_DOCKER_VERSION
apt-mark hold docker-ce

# Give user rights to run docker
sudo usermod -aG docker $USER
