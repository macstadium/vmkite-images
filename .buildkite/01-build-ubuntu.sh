#!/bin/bash
set -euo pipefail

echo "--- :packer: Building base :ubuntu: 16.04"
packer build \
	-var headless=false \
	ubuntu-16.04-amd64.json