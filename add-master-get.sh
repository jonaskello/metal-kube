# Get files needed for additional master provisioning

# Set options to fail properly
exec 4>&1
BASH_XTRACEFD=4
set -Eeuxo pipefail
export SHELLOPTS

# Pack all certs etc. that needs to be copied to the new master node
temp_dir=$(mktemp -d)
trap "{ rm -rf $temp_dir; }" EXIT
pushd /etc/kubernetes
sudo tar -czf $temp_dir/certs.tar.gz pki/ca.crt pki/ca.key pki/sa.key pki/sa.pub pki/front-proxy-ca.crt pki/front-proxy-ca.key pki/etcd/ca.crt pki/etcd/ca.key admin.conf
tar -ztvf $temp_dir/certs.tar.gz
ls $temp_dir
popd
