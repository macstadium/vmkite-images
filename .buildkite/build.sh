#!/bin/bash
set -euo pipefail

echo "--- :mac: Building vmware image"
sudo make clean
make $@

echo "--- :mac: Uploading to vSphere"
cd output
find "$1" -type f ! -name '*.lck' -exec govc datastore.upload -ds "PURE1-1" {} {} \;