#!/bin/bash
set -eux

install_buildkite() {
  echo "Installing buildkite-agent"
  echo deb https://apt.buildkite.com/buildkite-agent unstable main > /etc/apt/sources.list.d/buildkite-agent.list
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 32A37959C2FA5C3C99EFBC32A79206696452D198
  apt-get update
  apt-get install -y buildkite-agent
  mv /tmp/buildkite-hooks/* /etc/buildkite-agent/hooks/
  chown -R buildkite-agent: /etc/buildkite-agent/hooks/
}

install_service() {
  sudo mv "$HOME/vmkite-buildkite-agent.sh" /usr/local/bin/vmkite-buildkite-agent
  sudo mv "$HOME/vmkite-buildkite-agent.service" /lib/systemd/system/vmkite-buildkite-agent.service
  sudo chmod +x /usr/local/bin/vmkite-buildkite-agent
  sudo systemctl enable vmkite-buildkite-agent
}

install_buildkite
install_service

# Write a version file so we can track which build this refers to
cat << EOF > /etc/vmkite-info
BUILDKITE_VERSION=$(buildkite-agent --version)
BUILDKITE_BUILD_NUMBER=$BUILDKITE_BUILD_NUMBER
BUILDKITE_BRANCH=$BUILDKITE_BRANCH
BUILDKITE_COMMIT=$BUILDKITE_COMMIT
EOF
