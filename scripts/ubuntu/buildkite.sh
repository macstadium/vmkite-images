#!/bin/bash
set -eux

BUILDKITE_VERSION=3.0-beta.23

install_buildkite() {
  echo "Installing buildkite-agent"
  curl -Lfs -o buildkite.tar.gz "https://github.com/buildkite/agent/releases/download/v${BUILDKITE_VERSION}/buildkite-agent-linux-amd64-${BUILDKITE_VERSION}.tar.gz"
  mkdir -p "$HOME/buildkite-agent"
  tar -xzf buildkite.tar.gz -C "$HOME/buildkite-agent"
  sudo mkdir -p /usr/local/bin
  sudo chmod +x "$HOME/buildkite-agent/buildkite-agent"
  sudo ln -snf "$HOME/buildkite-agent/buildkite-agent" /usr/local/bin/
}

install_service() {
  sudo mv "$HOME/vmkite-buildkite-agent.sh" /usr/local/bin/vmkite-buildkite-agent
  sudo mv "$HOME/vmkite-buildkite-agent.service" /lib/systemd/system/vmkite-buildkite-agent.service
  sudo chmod +x /usr/local/bin/vmkite-buildkite-agent
  sudo systemctl enable vmkite-buildkite-agent
}

install_buildkite
install_service
