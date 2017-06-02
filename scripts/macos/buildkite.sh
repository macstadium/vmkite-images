#!/bin/bash
set -eux

PROVISION_DIR="$HOME"

install_buildkite() {
  echo "Installing buildkite-agent"
  /usr/local/bin/brew tap buildkite/buildkite
  /usr/local/bin/brew install --devel buildkite-agent
  ls /usr/local/etc/buildkite-agent/hooks
  ls /tmp/buildkite-hooks
  #mv /tmp/buildkite-hooks/* /usr/local/etc/buildkite-agent/hooks/
}

install_launchd_daemon() {
  local script="vmkite-buildkite-agent.sh"
  local plist="com.macstadium.vmkite-buildkite-agent.plist"
  echo "Installing launchd service"
  sudo cp "${PROVISION_DIR}/$script" "/usr/local/bin/$script"
  sudo cp "${PROVISION_DIR}/$plist" "/Library/LaunchDaemons/$plist"
  sudo chmod 0755 "/usr/local/bin/$script"
  sudo launchctl load "/Library/LaunchDaemons/$plist"
}

install_utils() {
  /usr/local/bin/brew install awscli jq
}

install_utils
install_buildkite
install_launchd_daemon
