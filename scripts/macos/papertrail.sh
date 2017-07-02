#!/bin/bash
set -eux

PROVISION_DIR="$HOME"
REMOTE_SYSLOG_VERSION="v0.20-beta1"

install_remote_syslog2() {
  echo "Installing remote_syslog2"
  curl -Lfs -o remote_syslog2.tar.gz https://github.com/papertrail/remote_syslog2/releases/download/${REMOTE_SYSLOG_VERSION}/remote_syslog_darwin_amd64.tar.gz
  tar xzvf remote_syslog2.tar.gz
  chmod +x remote_syslog/remote_syslog
  sudo mv remote_syslog /usr/local/bin/remote_syslog
  rm -rf remote_syslog
}

install_launchd_daemon() {
  local plist="com.papertrailapp.remote_syslog.plist"
  echo "Installing launchd service"
  sudo cp "${PROVISION_DIR}/$plist" "/Library/LaunchDaemons/$plist"
  sudo launchctl load "/Library/LaunchDaemons/$plist"
}

sudo tee /etc/log_files.yml > /dev/null << EOF
files:
 - /var/log/system.log
 - /usr/local/var/log/buildkite-agent.log
 - /usr/local/var/log/buildkite-agent.error.log
 - /var/log/vmkite-buildkite-agent.log
destination:
  host: ${PAPERTRAIL_HOST}
  port: ${PAPERTRAIL_PORT}
  protocol: tls
EOF

if [ -n "${PAPERTRAIL_HOST}" ] || [ -n "${PAPERTRAIL_HOST}" ] ; then
  install_remote_syslog2
  install_launchd_daemon
fi
