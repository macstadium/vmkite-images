#!/bin/bash

cache_dir="/usr/local/var/buildkite-agent/cache"
installer_path=$(buildkite-agent meta-data get installer_path)
version=$(basename "$installer_path" | cut -d_ -f3)
installer_build=$(basename "$installer_path" | cut -d_ -f4)

build_hash() {
  find prepare_iso/ "$installer_build" -type f -print0 | xargs -0 shasum | awk '{print $1}' | sort | shasum | awk '{print $1}'
}

output_cache_path="${cache_dir}/output/$(build_hash)-$(version)-$(installer_build)"

echo "+++ Running :packer: build for :mac: $version ($installer_build)"
packer build \
	-var iso_url="$installer_path" \
	-var version="$version" \
	-var packer_headless=true \
	-var output_dir="$output_cache_path" \
	macos.json

vmx_path=$(ls -1 $output_cache_path/*.vmx)
echo "+++ Built VMX $vmx_path"

buildkite-agent meta-data set base_vmx_path "$vmx_path"