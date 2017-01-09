#!/bin/bash
set -euxo pipefail

cache_dir="/usr/local/var/buildkite-agent/cache"
installer_path=$(buildkite-agent meta-data get installer_path)
version=$(basename "$installer_path" | cut -d_ -f3)

build_hash() {
	find scripts/macos "$installer_path" -type f -print0 \
		| xargs -0 shasum | awk '{print $1}' | sort | shasum | awk '{print $1}'
}

output_cache_path="${cache_dir}/output/$(build_hash)"

if [[ -d "$output_cache_path" ]] ; then
	echo "Output is in cache already, skipping building"
else
	echo "--- Running packer for base :mac: $version"
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

echo "+++ Built VMX $vmx_path"
buildkite-agent meta-data set base_vmx_path "$vmx_path"