#!/bin/bash
set -eux

VMKITE_VERSION="v1.5.0"

install_vmkite() {
  echo "Installing vmkite"
  curl -Lfs -o vmkite https://github.com/macstadium/vmkite/releases/download/${VMKITE_VERSION}/vmkite_darwin_amd64
  sudo mv vmkite /usr/local/bin/vmkite
}

install_service() {
  sudo mv "$HOME/vmkite-wrapper.sh" /usr/local/bin/vmkite-wrapper
  sudo chmod +x /usr/local/bin/vmkite-wrapper
  sudo mv "$HOME/vmkite.service" /lib/systemd/system/vmkite.service
  sudo systemctl enable vmkite
}

install_vmkite
install_service