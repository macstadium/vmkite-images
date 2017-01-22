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
	macos-buildkite.json

if ! ls output/buildkite-macos/*.vmdk &> /dev/null ; then
	echo "Failed to find any vmdk files in output/buildkite-macos"
	exit 1
fi

upload_path="vmkite/buildkite-macOS-${osx_version}/build-$BUILDKITE_BUILD_NUMBER"

echo "+++ Uploading to $upload_path"
find output/buildkite-macos -name '*.vmdk' -print -execdir \
	govc datastore.upload {} "${upload_path}/{}" \;