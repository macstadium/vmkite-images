#!/bin/bash
set -eux

# https://github.com/KrauseFx/xcode-install#installation
curl -sL -O https://github.com/neonichu/ruby-domain_name/releases/download/v0.5.99999999/domain_name-0.5.99999999.gem
gem install domain_name-0.5.99999999.gem
gem install --conservative xcode-install
rm -f domain_name-0.5.99999999.gem

# Install cli tools
/usr/local/bin/xcversion install-cli-tools