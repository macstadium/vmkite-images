#!/bin/bash
set -eux

su - vmkite -c \
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
