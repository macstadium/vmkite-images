#!/bin/bash
set -euxo pipefail

export XCODE_INSTALL_USER=$FASTLANE_USER
export XCODE_INSTALL_PASSWORD=$FASTLANE_PASSWORD
export XCODE_INSTALL_CACHE=$HOME/Library/Caches/XcodeInstall

/usr/local/bin/xcversion list
/usr/local/bin/xcversion install "$XCODE_VERSION"

rm -rf "$XCODE_INSTALL_CACHE"