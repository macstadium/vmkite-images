#!/bin/bash

cache_dir="/usr/local/var/buildkite-agent/cache"
installer_path=$(buildkite-agent meta-data get installer_path)
version=$(basename "$installer_path" | cut -d_ -f3)
installer_build=$(basename "$installer_path" | cut -d_ -f4)

echo "+++ Running :packer: build for :mac: $version ($installer_build)"
packer build \
	-var iso_url="$installer_path" \
	-var version="$version" \
	-var packer_headless=true \
	macos.json

build_hash() {
  find prepare_iso/ "$installer_build" -type f -print0 | xargs -0 shasum | awk '{print $1}' | sort | shasum | awk '{print $1}'
}

output_cache_path="${cache_dir}/output/$(build_hash)"

mkdir -p "$output_cache_path"
cp -a "output/$version/*" "$output_cache_path/"

echo "--- Output VMX files"
ls -al "$output_cache_path"