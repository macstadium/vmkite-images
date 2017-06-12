#!/bin/bash

set -e
set -o pipefail
set -u

exec > /var/log/vmkite-buildkite-agent.log 2>&1

guestinfo() {
  local key="guestinfo.$1"
  local default="${2:-}"

  ("/Library/Application Support/VMware Tools/vmware-tools-daemon" \
    --cmd "info-get $key" 2>/dev/null ) || echo "$default"
}

vmdk=$(guestinfo vmkite-vmdk)
name=$(guestinfo vmkite-name)
token=$(guestinfo vmkite-buildkite-agent-token)
queue=$(guestinfo vmkite-queue "vmkite")
debug=$(guestinfo vmkite-buildkite-debug "")
auto_shutdown=$(guestinfo vmkite-buildkite-auto-shutdown "true")

[[ -n $vmdk && -n $name && -n $token ]] || exit 10
[[ -z $auto_shutdown || $auto_shutdown =~ (true|1) ]] && trap "shutdown -h now" EXIT

export AWS_ACCESS_KEY_ID=$(guestinfo aws-access-key-id)
export AWS_SECRET_ACCESS_KEY=$(guestinfo aws-secret-access-key)
export VMKITE_API_HOST=$(guestinfo vmkite-api)
export VMKITE_API_TOKEN=$(guestinfo vmkite-api-token)

export BUILDKITE_AGENT_TOKEN="$token"
export BUILDKITE_AGENT_NAME="$name"
export BUILDKITE_AGENT_META_DATA="queue=$queue,vmkite-vmdk=$vmdk,vmkite-guestid=darwin13_64Guest"
export BUILDKITE_AGENT_DEBUG="$debug"

su vmkite -c "/usr/local/bin/buildkite-agent start --disconnect-after-job"