#!/bin/bash
set -eux

curl -fsSL -o install-homebrew \
  https://raw.githubusercontent.com/Homebrew/install/master/install

chmod +x install-homebrew
./install-homebrew
rm install-homebrew