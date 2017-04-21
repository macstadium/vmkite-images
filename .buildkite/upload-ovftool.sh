#!/bin/bash
set -euo pipefail

upload_vmx() {
  local vmx_path="$1"
  local base_name=$(basename "$(dirname "$vmx_path")")
  local vm_name="${base_name}-r${BUILDKITE_BUILD_NUMBER:-0}"

  echo "+++ Uploading $vmx_path to ${VSPHERE_DATACENTER}:/${vm_name}"
  ovftool \
    --acceptAllEulas \
    --name="$vm_name" \
    --datastore="$VSPHERE_DATASTORE" \
    --noSSLVerify=true \
    --diskMode=thin \
    --vmFolder=/ \
    --network="$VSPHERE_NETWORK" \
    --X:logLevel=verbose \
    --overwrite \
    "$vmx_path" \
    "vi://${VSPHERE_USERNAME}:${VSPHERE_PASSWORD}@${VSPHERE_HOST}/${VSPHERE_DATACENTER}/host/${VSPHERE_CLUSTER}"
}

find "$OUTPUT_DIR" -name "*.vmx" | while read -r vmx ; do
  upload_vmx "$vmx"
done
