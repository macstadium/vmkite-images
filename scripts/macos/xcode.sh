#!/bin/bash
set -euo pipefail
source ~/.bash_profile

if [ -z "${XCODE_VERSION:-}" ] ; then
  echo "Must set \$XCODE_VERSION"
  exit 1
fi

gem install xcode-install
xcversion install "$XCODE_VERSION"
xcversion cleanup