#!/bin/bash

set -e
set -u

BUILDKITE_VERSION=3.0-beta.19

install_buildkite() {
  echo "Installing buildkite-agent"
  curl -Lfs -o buildkite.tar.gz "https://github.com/buildkite/agent/releases/download/v${BUILDKITE_VERSION}/buildkite-agent-linux-${BUILDKITE_VERSION}.tar.gz"
  mkdir -p "$HOME/buildkite-agent"
  tar -xzf buildkite.tar.gz -C "$HOME/buildkite-agent"
  sudo mkdir -p /usr/local/bin
  sudo chmod +x "$HOME/buildkite-agent/buildkite-agent"
  sudo ln -snf "$HOME/buildkite-agent/buildkite-agent" /usr/local/bin/
}

install_service() {
  sudo mv /tmp/vmkite/vmkite-buildkite-agent.sh /usr/local/bin/vmkite-buildkite-agent
  sudo mv /tmp/vmkite/vmkite-buildkite-agent.service /lib/systemd/system/vmkite-buildkite-agent.service
  sudo systemctl enable vmkite-buildkite-agent
}

install_buildkite
install_service
