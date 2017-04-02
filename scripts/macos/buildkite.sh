#!/bin/bash

set -e
set -u

BUILDKITE_VERSION=3.0-beta.19

install_buildkite() {
  echo "Installing buildkite-agent"
  curl -Lfs -o buildkite.tar.gz "https://github.com/buildkite/agent/releases/download/v${BUILDKITE_VERSION}/buildkite-agent-linux-v${BUILDKITE_VERSION}.tar.gz"
  mkdir -p "$HOME/buildkite-agent"
  tar -xzf buildkite.tar.gz -C "$HOME/buildkite-agent"
  sudo mkdir -p /usr/local/bin
  sudo chmod +x "$HOME/buildkite-agent/buildkite-agent"
  sudo ln -snf "$HOME/buildkite-agent/buildkite-agent" /usr/local/bin/
}

install_launchd_daemon() {
  local script="vmkite-buildkite-agent.sh"
  local plist="com.macstadium.vmkite-buildkite-agent.plist"
  echo "Installing launchd service"
  cp "/tmp/vmkite/$script" "/usr/local/bin/$script"
  cp "/tmp/vmkite/$plist" "/Library/LaunchDaemons/$plist"
  sudo chmod 0755 "/usr/local/bin/$script"
  sudo launchctl load "/Library/LaunchDaemons/$plist"
}

install_buildkite
install_launchd_daemon
