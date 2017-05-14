#!/bin/bash
set -eux

su - "$USERNAME" -c \
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
