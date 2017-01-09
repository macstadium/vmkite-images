#!/bin/bash
set -euo pipefail

vmx_path=$(buildkite-agent meta-data get base_vmx_path)

echo "+++ Running :packer: build for :buildkite:"
echo $vmx_path

packer build \
	-var vmx_path="$vmx_path" \
	-var packer_headless=true \
	macos-buildkite.json
