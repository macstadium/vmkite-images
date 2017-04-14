#!/bin/bash
set -eux

VMKITE_VERSION=v1.1.0

install_vmkite() {
  echo "Installing vmkite"
  mkdir -p "$HOME/vmkite"
  curl -Lfs -o "$HOME/vmkite/vmkite" "https://github.com/macstadium/vmkite/releases/download/${VMKITE_VERSION}/vmkite_linux_amd64"
  sudo mkdir -p /usr/local/bin
  sudo chmod +x "$HOME/vmkite/vmkite"
  sudo ln -snf "$HOME/vmkite/vmkite" /usr/local/bin/
}

install_service() {
  sudo mv "$HOME/vmkite-wrapper.sh" /usr/local/bin/vmkite-wrapper
  sudo chmod +x /usr/local/bin/vmkite-wrapper
  sudo mv "$HOME/vmkite.service" /lib/systemd/system/vmkite.service
  sudo systemctl enable vmkite
}

install_vmkite
install_service
