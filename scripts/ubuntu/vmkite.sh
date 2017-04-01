#!/bin/bash

set -e
set -o pipefail
set -u

BUILDKITE_VERSION=3.0-beta.19
VMKITE_VERSION=1.0.0

install_buildkite() {
  echo "Installing buildkite-agent"
  curl -Lfs -o buildkite.tar.gz "https://github.com/buildkite/agent/releases/download/v${BUILDKITE_VERSION}/buildkite-agent-linux-v${BUILDKITE_VERSION}.tar.gz"
  mkdir -p "$HOME/buildkite-agent"
  tar -xzf buildkite.tar.gz -C "$HOME/buildkite-agent"
  sudo mkdir -p /usr/local/bin
  sudo chmod +x "$HOME/buildkite-agent/buildkite-agent"
  sudo ln -snf "$HOME/buildkite-agent/buildkite-agent" /usr/local/bin/
}

install_vmkite() {
  echo "Installing vmkite"
  sudo curl -Lfs -o /usr/local/bin/vmkite "https://github.com/buildkite/agent/releases/download/v${VMKITE_VERSION}/vmkite_linux_amd64"
  sudo chmod +x /usr/local/bin/vmkite
  sudo systemctl enable vmkite
}

install_buildkite
install_vmkite
