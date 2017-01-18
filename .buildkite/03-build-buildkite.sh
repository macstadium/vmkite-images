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

if ! vmx_path=$(ls -1 output/buildkite-macos/*.vmx) ; then
	echo "Failed to find any vmx files in output/buildkite-macos"
	exit 1
fi

vm_image="vmkite/buildkite-macOS-10.12/build-$BUILDKITE_BUILD_NUMBER.vmdk"

echo "+++ Uploading to $vm_image"
cd $(dirname $vmx_path)
govc datastore.upload "$(basename $vmx_path)" "$vm_image"
