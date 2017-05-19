#!/bin/bash
set -euxo pipefail

export XCODE_INSTALL_USER=$FASTLANE_USER
export XCODE_INSTALL_PASSWORD=$FASTLANE_PASSWORD

/usr/local/bin/xcversion list
/usr/local/bin/xcversion install "$XCODE_VERSION"