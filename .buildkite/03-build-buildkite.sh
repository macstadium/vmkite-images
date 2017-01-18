#!/bin/bash
set -euo pipefail

vmx_path=$(buildkite-agent meta-data get base_vmx_path)
osx_version=$(buildkite-agent meta-data get base_osx_version)

echo "+++ :packer: Building :buildkite: image from base"
echo Path to VMX is "$vmx_path"

test -d output && rm -rf output/
packer build \
	-var vmx_path="$vmx_path" \
	-var packer_headless=true \
	macos-buildkite.json

if ! vmdk_path=$(ls -1 output/buildkite-macos/*.vmdk) ; then
	echo "Failed to find any vmdk files in output/buildkite-macos"
	exit 1
fi

upload_path="vmkite/buildkite-macOS-${osx_version}/build-$BUILDKITE_BUILD_NUMBER.vmdk"

echo "+++ Uploading ${vmdk_path} to ${upload_path}"
cd output/buildkite-macos/
govc datastore.upload "$(basename "$vmdk_path")" "$upload_path"
