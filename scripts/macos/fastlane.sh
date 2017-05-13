#!/bin/bash
set -euxo pipefail

gem install xcode-install
xcversion install "$XCODE_VERSION"