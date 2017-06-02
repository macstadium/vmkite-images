#!/bin/bash
set -eux

PROVISION_DIR="$HOME"

echo $PATH

# echo export PATH="/usr/local/bin:$PATH" >> ~/.bash_profile

install_buildkite() {
  echo "Installing buildkite-agent"
  /usr/local/bin/brew tap buildkite/buildkite
  /usr/local/bin/brew install --devel buildkite-agent
  mv /tmp/buildkite-hooks/* /usr/local/etc/buildkite-agent/hooks/
}

install_launchd_daemon() {
  local script="vmkite-buildkite-agent.sh"
  local plist="com.macstadium.vmkite-buildkite-agent.plist"
  echo "Installing launchd service"
  cp "${PROVISION_DIR}/$script" "/usr/local/bin/$script"
  cp "${PROVISION_DIR}/$plist" "/Library/LaunchDaemons/$plist"
  sudo chmod 0755 "/usr/local/bin/$script"
  sudo launchctl load "/Library/LaunchDaemons/$plist"
}

install_buildkite
install_launchd_daemon
