#!/bin/bash
set -euo pipefail

hash_files() {
  find "$@" -type f -print0 \
    | xargs -0 sha1sum \
    | awk '{print $1}' \
    | sort \
    | sha1sum \
    | awk '{print $1}'
}

case "${1:-}" in
macos-10.12)
  filehash=$(hash_files scripts/common scripts/macos macos-10.12.json)
  ;;
ubuntu-16.04)
  filehash=$(hash_files scripts/common scripts/ubuntu ubuntu-16.04.json)
  ;;
vmkite)
  filehash=$(hash_files scripts/common scripts/ubuntu vmkite.json)
  ;;
*)
  filehash=""
  ;;
esac

if [[ -n $filehash ]] && [[ -e "$HASHES_DIR/${filehash}" ]] ; then
  target=$(readlink "$HASHES_DIR/${filehash}")
  echo "Build already exists at ${target}"
  ln -sf "$target" "${OUTPUT_DIR}"
else
  make "$@" "output_directory=$OUTPUT_DIR"
  if [[ -n "${filehash}" ]] ; then
    echo "Linking hash of ${filehash} to ${OUTPUT_DIR}"
    mkdir -p "$HASHES_DIR"
    ln -sf "${HASHES_DIR}/${filehash}" "${OUTPUT_DIR}"
  fi
fi

ls -al ${OUTPUT_DIR}

# vm_name=""


# upload_path="${VMKITE_SCP_PATH}/${base_name}-r${BUILDKITE_BUILD_NUMBER:-0}"

#   echo "+++ Uploading $disk to $remote_path"
#   sftp -b <(echo put -r "${disk}/" "${remote_path}") \
#     -P"${VMKITE_SCP_PORT}" "${VMKITE_SCP_USER}@${VMKITE_SCP_HOST}"
# }