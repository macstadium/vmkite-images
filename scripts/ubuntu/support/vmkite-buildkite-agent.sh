#!/bin/bash

set -e
set -o pipefail
set -u


guestinfo() {
  local key="guestinfo.$1"
  local value
  if value=$(/usr/bin/vmware-rpctool "info-get $key") ; then
    echo "$value"
  else
    echo >&2 "Missing $key"
  fi
}

echo "--- Querying VMware guestinfo"
vmdk=$(guestinfo vmkite-vmdk)
name=$(guestinfo vmkite-name)
token=$(guestinfo vmkite-buildkite-agent-token)
debug=$(guestinfo vmkite-buildkite-debug)

[[ -n $vmdk && -n $name && -n $token ]] || exit 10

aws_access_key_id=$(guestinfo aws-access-key-id)
aws_secret_access_key=$(guestinfo aws-secret-access-key)

export AWS_ACCESS_KEY_ID="$aws_access_key_id"
export AWS_SECRET_ACCESS_KEY="$aws_secret_access_key"

echo "--- Starting buildkite-agent"
export BUILDKITE_AGENT_TOKEN="$token"
export BUILDKITE_AGENT_NAME="$name"
export BUILDKITE_AGENT_META_DATA="vmkite-vmdk=$vmdk,vmkite-guestid=ubuntu64Guest"
export BUILDKITE_AGENT_DEBUG="$debug"

su buildkite-agent -c "/usr/bin/buildkite-agent start --disconnect-after-job"
echo "--- Buildkite exited with $?, shutting down machine"
shutdown -h now