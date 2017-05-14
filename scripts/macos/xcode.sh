#!/bin/bash
set -euxo pipefail

gem env
gem install xcode-install
/usr/local/bin/xcversion install "$XCODE_VERSION"