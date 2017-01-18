#!/bin/bash
set -euo pipefail

vmx_path=$(buildkite-agent meta-data get base_vmx_path)
vmx_dir=$(dirname "$vmx_path")
vm_image="vmkite/macOS-10.12/build-$BUILDKITE_BUILD_NUMBER"

echo "+++ Uploading to $vm_image"
find "$vmx_dir" -type f -print -execdir govc datastore.upload {} "$vm_image"/{} \;