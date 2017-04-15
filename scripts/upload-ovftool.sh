#!/bin/bash
set -euo pipefail

VMX_PATH=output/ubuntu-16.04-amd64/ubuntu-16.04-amd64.vmx
VM_NAME=vmkite-my-test-vm
VSPHERE_DATASTORE=PURE_1_1
VSPHERE_NETWORK=MY_NETWORK
VSPHERE_USERNAME=admin%40example.org
VSPHERE_PASSWORD=llamas
VSPHERE_HOST=10.92.x.x
VSPHERE_DATACENTER="MacStadium - Vegas"
VSPHERE_CLUSTER="XSERVE_Cluster"

ovftool \
  --acceptAllEulas \
  --name="$VM_NAME" \
  --datastore="$VSPHERE_DATASTORE" \
  --noSSLVerify=true \
  --diskMode=thin \
  --vmFolder=/ \
  --network="$VSPHERE_NETWORK" \
  --X:logLevel=verbose \
  "$VMX_PATH" \
  "vi://${VSPHERE_USERNAME}:${VSPHERE_PASSWORD}@${VSPHERE_HOST}/${VSPHERE_DATACENTER}/host/${VSPHERE_CLUSTER}"