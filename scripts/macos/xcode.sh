#!/bin/bash
set -euxo pipefail

if [ -z "${XCODE_VERSION:-}" ] ; then
  echo "Must set \$XCODE_VERSION"
  exit 1
fi

tar xf "/tmp/xcode-${XCODE_VERSION}.tar" -C /Applications
ls -al /Applications