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
	-var packer_output_dir=output/buildkite-macos \
	-var osx_version="$osx_version" \
	-var packer_headless=true \
	-var vsphere_username="$GOVC_USERNAME" \
	-var vsphere_password="$GOVC_PASSWORD" \
	-var build_number="$BUILDKITE_BUILD_NUMBER" \
	macos-buildkite.json
