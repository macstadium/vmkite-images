#!/bin/bash
set -euo pipefail

vmx_path=$(buildkite-agent meta-data get base_vmx_path)

echo "+++ Running :packer: build for :buildkite:"
echo Path to VMX is "$vmx_path"

test -d output && rm -rf output/
packer build \
	-var vmx_path="$vmx_path" \
	-var packer_headless=true \
	macos-buildkite.json

vmx_dir=output/buildkite-macos
vm_image="macos-10.12-buildkite-$(date +'%Y%m%d-%H%M%S')"

echo "+++ Uploading to $vm_image"
find "$vmx_dir" -type f -exec govc datastore.upload -ds "PURE1-1" {} "$vm_image"/{} \;
