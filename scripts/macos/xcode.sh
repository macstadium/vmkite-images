#!/bin/bash
set -euo pipefail
source ~/.bash_profile

gem install xcode-install

if [ -z "${XCODE_VERSION:-}" ] ; then
  echo "Must set \$XCODE_VERSION"
  exit 1
fi

xcversion install "$XCODE_VERSION"
xcversion cleanup