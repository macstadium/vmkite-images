#!/bin/bash
set -euxo pipefail

export PATH=/usr/local/bin:$PATH

gem install xcode-install

if [ -z "${XCODE_VERSION:-}" ] ; then
  echo "Must set \$XCODE_VERSION"
  exit 1
fi

xcversion install "$XCODE_VERSION"
xcversion cleanup