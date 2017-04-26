# #!/bin/bash
# set -euo pipefail

# upload_to_sftp() {
#   local source_dir="$1"
#   local vm_name=$(basename "$source_dir")
#   local remote_path="${VMKITE_SCP_PATH}/${base_name}-r${BUILDKITE_BUILD_NUMBER:-0}"

#   echo "+++ Uploading $disk to $remote_path"
#   sftp -b <(echo put -r "${disk}/" "${remote_path}") \
#     -P"${VMKITE_SCP_PORT}" "${VMKITE_SCP_USER}@${VMKITE_SCP_HOST}"
# }

# find "$OUTPUT_DIR" -name "disk.vmdk" | while read -r disk ; do
#   upload_to_sftp "$(dirname "$disk")"
# done