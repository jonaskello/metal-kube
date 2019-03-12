#!/bin/bash

# This script needs 3 parameters:
# $1: Version of docker to install
# $2: Version of kubernetes binaries to install
# $3: The join command

# Set options to fail properly
exec 4>&1
BASH_XTRACEFD=4
set -Eeuxo pipefail
export SHELLOPTS

# Verify arguments ($1 and $2 are checked by the init-node script)
if [ -z "$3" ]
  then
    echo "The argument for join command was not supplied."
fi

# Run init
curl -fsSL https://raw.githubusercontent.com/jonaskello/metal-kube/master/init-node.sh | bash -s -- $1 $2

# Run join
eval sudo $3
