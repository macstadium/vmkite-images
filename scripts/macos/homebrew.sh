#!/bin/bash
set -eux

# Install xcode tools
touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
PROD=$(softwareupdate -l |
  grep "\*.*Command Line" |
  head -n 1 | awk -F"*" '{print $2}' |
  sed -e 's/^ *//' |
  tr -d '\n')
softwareupdate -i "$PROD" -v;

curl -fsSL -o install-homebrew \
  https://raw.githubusercontent.com/Homebrew/install/master/install

chmod +x install-homebrew
./install-homebrew
rm install-homebrew

# Add homebrew to path
echo "export PATH=/usr/local/bin:$PATH" >> ~/.bash_profile