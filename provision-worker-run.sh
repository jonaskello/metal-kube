# This script needs 3 parameters:
# 1. Version of docker to install
# 2. Version of kubernetes binaries to install
# 3. The join command

# Verify arguments
if [ -z "$3" ]
  then
    echo "The argument for join command was not supplied."
fi

echo "Param1: $1"
echo "Param2: $2"
echo "Param3: $3"

# Run init
curl -fsSL https://raw.githubusercontent.com/jonaskello/metal-kube/master/init-node.sh | bash -s -- $1 $2
