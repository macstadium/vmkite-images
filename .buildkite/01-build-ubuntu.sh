#!/bin/bash
set -euo pipefail

echo "--- :packer: Building base :ubuntu: 16.04"
packer build \
	-var packer_headless=false \
	-var vsphere_username="$GOVC_USERNAME" \
	-var vsphere_password="$GOVC_PASSWORD" \
	-var build_number="$BUILDKITE_BUILD_NUMBER" \
	-var esxi_host="10.92.157.10" \
	ubuntu-1604-base.json