#!/bin/bash
set -euo pipefail

echo "--- :packer: Building base :ubuntu: 16.04"
packer build \
	-var headless=false \
	ubuntu-1604-base.json