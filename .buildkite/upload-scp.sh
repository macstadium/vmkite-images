#!/bin/bash
set -euo pipefail

upload_vmdk() {
  local disk="$1"
  local base_name=$(basename "$(dirname "$disk")")
  local remote_path="${VMKITE_SCP_PATH}/${base_name}-r${BUILDKITE_BUILD_NUMBER:-0}.vmdk"

  echo "--- Uploading $disk to $remote_path"
  sftp -P "${VMKITE_SCP_PORT}" "${VMKITE_SCP_USER}@${VMKITE_SCP_HOST}" -- \
    put -r "${disk}" "${remote_path}"
}

find "$OUTPUT_DIR" -name "disk.vmdk" | while read -r disk ; do
  upload_vmdk "$disk"
done