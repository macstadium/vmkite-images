#!/bin/bash
set -euxo pipefail

if [ -z "${XCODE_VERSION:-}" ] ; then
  echo "Must set \$XCODE_VERSION"
  exit 1
fi

xcversion install "$XCODE_VERSION"