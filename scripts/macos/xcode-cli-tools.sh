#!/bin/bash
set -eux

# https://github.com/KrauseFx/xcode-install#installation
sudo gem install xcode-install

# Install cli tools
/usr/local/bin/xcversion install-cli-tools