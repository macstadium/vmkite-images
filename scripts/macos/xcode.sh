#!/bin/bash
set -euo pipefail
source ~/.bash_profile

if [ -z "${XCODE_VERSION:-}" ] ; then
  echo "Must set \$XCODE_VERSION"
  exit 1
fi

echo $PATH
cat ~/.bash_profile
eval "$(rbenv init -)"
rbenv versions
rbenv rehash
gem env

gem install xcode-install
rbenv rehash

ls -alR /Users/vmkite/Library/Caches
sudo chown -R vmkite: /Users/vmkite/Library/Caches

xcversion install "$XCODE_VERSION"
xcversion cleanup