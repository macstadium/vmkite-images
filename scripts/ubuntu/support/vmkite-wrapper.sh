#!/bin/bash

set -e
set -o pipefail
set -u

guestinfo() {
  local key="guestinfo.$1"
  local value
  if value=$(/usr/bin/vmware-rpctool "info-get $key" 2>/dev/null) ; then
    echo "$value"
  elif [ -n "${2:-}" ] ; then
    echo "$2"
  else
    echo >&2 "Missing $key"
    return 1
  fi
}

echo "--- Querying VMware guestinfo"

VMKITE_BUILDKITE_AGENT_TOKEN="$(guestinfo vmkite-buildkite-agent-token)"
VMKITE_BUILDKITE_API_TOKEN="$(guestinfo vmkite-buildkite-api-token)"
VMKITE_BUILDKITE_ORG="$(guestinfo vmkite-buildkite-org)"
VMKITE_BUILDKITE_DEBUG="$(guestinfo vmkite-buildkite-debug)"
VMKITE_SOURCE_DATASTORE="$(guestinfo vmkite-source-datastore)"
VMKITE_TARGET_DATASTORE="$(guestinfo vmkite-target-datastore)"
VMKITE_VM_CLUSTER_PATH="$(guestinfo vmkite-cluster-path '')"
VMKITE_VM_MEMORY_MB="$(guestinfo vmkite-vm-memory 4096)"
VMKITE_VM_NETWORK_LABEL="$(guestinfo vmkite-vm-network-label)"
VMKITE_VM_NUM_CORES_PER_SOCKET=1
VMKITE_VM_NUM_CPUS="$(guestinfo vmkite-vm-num-cpus 2)"
VMKITE_VM_PATH="$(guestinfo vmkite-vm-path)"
VMKITE_VM_AWS_ACCESS_KEY_ID="$(guestinfo vmkite-vm-aws-access-key-id)"
VMKITE_VM_AWS_SECRET_ACCESS_KEY="$(guestinfo vmkite-vm-aws-secret-access-key)"
VMKITE_VSPHERE_HOST="$(guestinfo vmkite-vsphere-host)"
VMKITE_VSPHERE_INSECURE="$(guestinfo vmkite-vsphere-insecure 'true')"
VMKITE_VSPHERE_PASS="$(guestinfo vmkite-vsphere-pass)"
VMKITE_VSPHERE_USER="$(guestinfo vmkite-vsphere-user)"

export VMKITE_VSPHERE_HOST
export VMKITE_VSPHERE_INSECURE
export VMKITE_VSPHERE_PASS
export VMKITE_VSPHERE_USER
export VMKITE_BUILDKITE_AGENT_TOKEN
export VMKITE_BUILDKITE_API_TOKEN
export VMKITE_BUILDKITE_ORG
export VMKITE_BUILDKITE_DEBUG
export VMKITE_SOURCE_DATASTORE
export VMKITE_TARGET_DATASTORE
export VMKITE_VM_CLUSTER_PATH
export VMKITE_VM_MEMORY_MB
export VMKITE_VM_NETWORK_LABEL
export VMKITE_VM_NUM_CORES_PER_SOCKET
export VMKITE_VM_NUM_CPUS
export VMKITE_VM_PATH
export VMKITE_VM_AWS_ACCESS_KEY_ID
export VMKITE_VM_AWS_SECRET_ACCESS_KEY

exec /usr/local/bin/vmkite \
  --vm-guest-info "vmkite-buildkite-debug=${VMKITE_BUILDKITE_DEBUG}" \
  --vm-guest-info "aws-access-key-id=${VMKITE_VM_AWS_ACCESS_KEY_ID}" \
  --vm-guest-info "aws-secret-access-key=${VMKITE_VM_AWS_SECRET_ACCESS_KEY}" \
  "$@"
