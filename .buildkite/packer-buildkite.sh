#!/bin/bash
set -euo pipefail

vmx_path=$(buildkite-agent meta-data get base_vmx_path)

echo "+++ :packer: Building :buildkite: image from base"
echo Path to VMX is "$vmx_path"

test -d output && rm -rf output/
packer build \
	-var vmx_path="$vmx_path" \
	-var packer_headless=true \
	macos-buildkite.json

vmx_dir=output/buildkite-macos
vm_image="vmkite/buildkite-macOS-10.12/build-$BUILDKITE_BUILD_NUMBER"

echo "+++ Uploading to $vm_image"
find "$vmx_dir" -type f -print -execdir govc datastore.upload {} "$vm_image"/{} \;
