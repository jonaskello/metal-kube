# This script needs 3 parameters:
# 1. Version of docker to install
# 2. Version of kubernetes binaries to install
# 3. The join command

# Run init
curl -fsSL https://raw.githubusercontent.com/jonaskello/metal-kube/master/init-node.sh | bash
