#!/bin/bash
set -euo pipefail

echo "--- :mac: Preparing installer for macOS Sierra"
sudo SUDO_UID="$UID" SUDO_GID="$GID" \
  prepare_iso/prepare_iso.sh "/Applications/Install macOS Sierra.app" installers
