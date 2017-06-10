#!/bin/bash
set -eux

# Add homebrew to path
echo "export PATH=/usr/local/bin:$PATH" >> ~/.bash_profile
source ~/.bash_profile

curl -fsSL -o install-homebrew \
  https://raw.githubusercontent.com/Homebrew/install/master/install

# install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap Homebrew/bundle