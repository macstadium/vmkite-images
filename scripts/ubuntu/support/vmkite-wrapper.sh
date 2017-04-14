#!/bin/bash

set -e
set -o pipefail
set -u

guestinfo() {
  local key="guestinfo.$1"
  local value
  if value=$(/usr/bin/vmware-rpctool "info-get $key") ; then
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
VMKITE_SOURCE_DATASTORE="$(guestinfo vmkite-source-datastore PURE1-1)"
VMKITE_TARGET_DATASTORE="$(guestinfo vmkite-target-datastore PURE1-1)"
VMKITE_VM_CLUSTER_PATH="$(guestinfo vmkite-cluster-path '/MacStadium - Vegas/host/XSERVE_Cluster')"
VMKITE_VM_MEMORY_MB="$(guestinfo vmkite-vm-memory 4096)"
VMKITE_VM_NETWORK_LABEL="$(guestinfo vmkite-vm-network-label 'dvPortGroup-Private-1')"
VMKITE_VM_NUM_CORES_PER_SOCKET=1
VMKITE_VM_NUM_CPUS="$(guestinfo vmkite-vm-num-cpus 2)"
VMKITE_VM_PATH="$(guestinfo vmkite-vm-path '/MacStadium - Vegas/vm')"

export VMKITE_BUILDKITE_AGENT_TOKEN
export VMKITE_BUILDKITE_API_TOKEN
export VMKITE_BUILDKITE_ORG
export VMKITE_SOURCE_DATASTORE
export VMKITE_TARGET_DATASTORE
export VMKITE_VM_CLUSTER_PATH
export VMKITE_VM_MEMORY_MB
export VMKITE_VM_NETWORK_LABEL
export VMKITE_VM_NUM_CORES_PER_SOCKET
export VMKITE_VM_NUM_CPUS
export VMKITE_VM_PATH

exec /usr/local/bin/vmkite "$@"