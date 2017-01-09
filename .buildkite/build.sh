#!/bin/bash
set -euo pipefail

sudo make clean
make $@

govc datastore.upload -ds "PURE1-1" ./output/macos-10.12.1 macos-10.12.1/
