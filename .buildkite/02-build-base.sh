#!/bin/bash
set -euo pipefail

cache_dir="/usr/local/var/buildkite-agent/cache"
installer_path=$(buildkite-agent meta-data get installer_path)
version=$(basename "$installer_path" | cut -d_ -f3)

build_hash() {
	find scripts/macos "$installer_path" -type f -print0 \
		| xargs -0 shasum | awk '{print $1}' | sort | shasum | awk '{print $1}'
}

output_cache_path="${cache_dir}/output/$(build_hash)"
upload=1

cleanup() {
	echo "Cleaning up cache path $output_cache_path"
	rm -rf "$output_cache_path"
}

trap cleanup ERR

if [[ -d "$output_cache_path" ]] ; then
	echo "Output is in cache already, skipping building"
	upload=0
else
	echo "--- :packer: Building base :mac: $version"
	packer build \
		-var iso_url="$installer_path" \
		-var version="$version" \
		-var packer_headless=true \
		-var packer_output_dir="$output_cache_path" \
		macos.json
fi

if ! vmx_path=$(ls -1 $output_cache_path/*.vmx) ; then
	echo "Failed to find any vmx files in $output_cache_path"
	exit 1
fi

vm_image="vmkite/buildkite-macOS-${version}/build-$BUILDKITE_BUILD_NUMBER.vmdk"

if [ $upload -eq 1 ] ; then
	echo "+++ Uploading to $vm_image"
	cd $(dirname $vmx_path)
	govc datastore.upload "$(basename $vmx_path)" "$vm_image"
fi

echo "+++ Built VMX $vmx_path"
buildkite-agent meta-data set base_vmx_path "$vmx_path"
buildkite-agent meta-data set base_osx_version "$version"