#!/bin/bash
set -eux

PROVISION_DIR="$HOME"

install_buildkite() {
  echo "Installing buildkite-agent"
  /usr/local/bin/brew tap buildkite/buildkite
  /usr/local/bin/brew install --devel buildkite-agent
  cp /tmp/buildkite-hooks/* /usr/local/etc/buildkite-agent/hooks/
  rm -rf /tmp/buildkite-hooks
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

# Write a version file so we can track which build this refers to
cat << EOF > /etc/vmkite-info
BUILDKITE_VERSION=$(buildkite-agent --version)
BUILDKITE_BUILD_NUMBER=$BUILDKITE_BUILD_NUMBER
BUILDKITE_BRANCH=$BUILDKITE_BRANCH
BUILDKITE_COMMIT=$BUILDKITE_COMMIT
EOF
