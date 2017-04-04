#!/bin/bash

set -e
set -o pipefail
set -u

guestinfo() {
  local key="guestinfo.$1"
  local tool="/Library/Application Support/VMware Tools/vmware-tools-daemon"
  local value=$("$tool" --cmd "info-get $key")
  if [[ -n $value ]]; then
    echo "$value"
  else
    echo >&2 "Missing $key"
  fi
}

echo "--- Querying VMware guestinfo"
vmdk=$(guestinfo vmkite-vmdk)
name=$(guestinfo vmkite-name)
token=$(guestinfo vmkite-buildkite-agent-token)

[[ -n $vmdk && -n $name && -n $token ]] || exit 10

echo "--- Starting buildkite-agent"
export BUILDKITE_AGENT_TOKEN="$token"
export BUILDKITE_AGENT_NAME="$name"
export BUILDKITE_AGENT_META_DATA="vmkite-vmdk=$vmdk,vmkite-guestid=darwin13_64Guest"
export BUILDKITE_BOOTSTRAP_SCRIPT_PATH="/Users/vmkite/buildkite-agent/bootstrap.sh"
export BUILDKITE_BUILD_PATH="/Users/vmkite/buildkite-builds"
su vmkite -c "/usr/local/bin/buildkite-agent start"

echo "--- Buildkite exited with $?, shutting down machine"
shutdown -h now