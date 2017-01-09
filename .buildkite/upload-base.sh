#!/bin/bash
set -euo pipefail

vmx_path=$(buildkite-agent meta-data get base_vmx_path)
vmx_dir=$(dirname "$vmx_path")
vm_image="macos-base-10.12-$(date +'%Y%m%d-%H%M%S')"

echo "+++ Uploading to $vm_image"
find "$vmx_dir" -type f -print -exec govc datastore.upload {} "$vm_image"/{} \;