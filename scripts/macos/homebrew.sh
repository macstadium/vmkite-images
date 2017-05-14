#!/bin/bash
set -euo pipefail

su - "$USERNAME" -c \
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
