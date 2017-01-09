#!/bin/bash
set -euo pipefail

base_vmx_path=$(buildkite-agent meta-data get base_vmx_path)

echo "+++ Running :packer: build for :buildkite:"
echo $base_vmx_path

# packer build \
# 	-var iso_url="$installer_path" \
# 	-var version="$version" \
# 	-var packer_headless=true \
# 	macos.json
