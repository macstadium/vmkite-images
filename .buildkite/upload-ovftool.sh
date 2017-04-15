#!/bin/bash
set -euo pipefail

find output -name '*.vmx'

# VMX_PATH=output/ubuntu-16.04-amd64/ubuntu-16.04-amd64.vmx
# VM_NAME=vmkite-my-test-vm

# ovftool \
#   --acceptAllEulas \
#   --name="$VM_NAME" \
#   --datastore="$VSPHERE_DATASTORE" \
#   --noSSLVerify=true \
#   --diskMode=thin \
#   --vmFolder=/ \
#   --network="$VSPHERE_NETWORK" \
#   --X:logLevel=verbose \
#   --overwrite \
#   "$VMX_PATH" \
#   "vi://${VSPHERE_USERNAME}:${VSPHERE_PASSWORD}@${VSPHERE_HOST}/${VSPHERE_DATACENTER}/host/${VSPHERE_CLUSTER}"