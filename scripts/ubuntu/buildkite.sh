#!/bin/sh

set -e
set -o pipefail
set -u

BUILDKITE_RELEASE="https://github.com/buildkite/agent/releases/download/v3.0-beta.19/buildkite-agent-darwin-linux-3.0-beta.19.tar.gz"

install_buildkite() {
  echo "Installing buildkite-agent"
  curl -Lfs -o buildkite.tar.gz "$BUILDKITE_RELEASE"
  mkdir -p "$HOME/buildkite-agent"
  tar -xzf buildkite.tar.gz -C "$HOME/buildkite-agent"
  sudo mkdir -p /usr/local/bin
  sudo ln -snf "$HOME/buildkite-agent/buildkite-agent" /usr/local/bin/
}

install_buildkite
install_launchd_daemon
