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

get_hash_for_image() {
  case "$1" in
  macos-10.12)
    hash_files scripts/common scripts/macos macos-10.12.json
    ;;
  ubuntu-16.04)
    hash_files scripts/common scripts/ubuntu ubuntu-16.04.json
    ;;
  vmkite)
    hash_files scripts/common scripts/ubuntu vmkite.json
    ;;
  esac
}

get_hash_path() {
  local image="$1"
  local filehash

  if ! filehash="$(get_hash_for_image "$image")" || [[ -z "$filehash" ]] ; then
    return
  fi

  echo "$HASHES_DIR/$image/${filehash}"
}

find_vm_name() {
  find "$1" -iname '*.vmx' -exec basename {} \; | head -n1 | sed 's/\.vmx//'
}

upload_vm_to_sftp() {
  local source_dir="$1"
  local upload_dir

  upload_dir="$(find_vm_name "$source_dir")"

  if ! sftp_command cd "$VMKITE_SCP_PATH/$upload_dir" ; then
    sftp_command mkdir "$VMKITE_SCP_PATH/$upload_dir"
  fi

  find "$source_dir" -type f -print0 | while IFS= read -r -d $'\0' f; do
    remote_path="$VMKITE_SCP_PATH/$upload_dir/$(basename "$f")"
    sftp_command put "$f" "$remote_path"
  done
}

sftp_command() {
  sftp -b <(echo "$*") \
    -P"${VMKITE_SCP_PORT}" \
    "${VMKITE_SCP_USER}@${VMKITE_SCP_HOST}"
}

export BUILD_DIR=${BUILD_DIR:-/tmp/vmkite-images}
export HASHES_DIR=${BUILD_DIR}/hashes/${BUILDKITE_BRANCH}
export OUTPUT_DIR=${BUILD_DIR}/output/${BUILDKITE_BUILD_ID}
export PACKER_CACHE_DIR=$HOME/.packer_cache

image="$1"
hashfile="$(get_hash_path "$image")"

if [[ -e $hashfile ]] ; then
  outputdir=$(readlink "$hashfile")
  echo "Image is already built at $hashfile"
  exit 0
fi

echo "+++ Building $image"
make "$@" "output_directory=$outputdir"

echo "+++ Uploading $outputdir to sftp"
upload_vm_to_sftp "$outputdir"

if [[ -n "$hashfile" ]] ; then
  echo "--- Linking $outputdir to $hashfile"
  mkdir -p "$(dirname "$hashfile")"
  ln -sf "$outputdir" "$hashfile"
fi