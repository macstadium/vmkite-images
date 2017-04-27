#!/bin/bash
set -euo pipefail

hash_strings() {
  sort \
    | sha1sum \
    | awk '{print $1}'
}

hash_files() {
  find "$@" -type f -print0 \
    | xargs -0 sha1sum \
    | awk '{print $1}' \
    | hash_strings
}

files_from_packer_template() {
  echo "$1".json
  jq -r '.provisioners[] | .source, .scripts[]? | select(. != null)' "$1".json \
    | xargs -n1 find
}

get_hash_path() {
  local image="$1"
  local sourcehash="$2"
  local filehash
  local imagehash

  files=( $(files_from_packer_template "$image") )

  echo "--- Finding files to hash" >&2;
  printf "%s\n" "${files[@]}"  >&2;

  filehash="$(files_from_packer_template "$image")"
  imagehash="$(echo "$filehash $sourcehash" | hash_strings)"

  echo "$HASHES_DIR/$image/${imagehash}"
}

find_vmx_file() {
  find "$1" -iname '*.vmx' | head -n1
}

upload_vm_to_sftp() {
  local source_dir="$1"
  local upload_dir

  upload_dir="$(basename "$(find_vmx_file "$source_dir")" | sed 's/\.vmx//')"

  if ! sftp_command cd "$VMKITE_SCP_PATH/$upload_dir" ; then
    sftp_command mkdir "$VMKITE_SCP_PATH/$upload_dir"
  fi

  find "$source_dir" -type f -print0 | while IFS= read -r -d $'\0' f; do
    remote_path="$VMKITE_SCP_PATH/$upload_dir/$(basename "$f")"
    sftp_put "$f" "$remote_path"
  done
}

sftp_command() {
  sftp -b <(echo "$*") \
    -P"${VMKITE_SCP_PORT}" \
    "${VMKITE_SCP_USER}@${VMKITE_SCP_HOST}"
}

sftp_put() {
  sftp -b <(echo -e "progress\nput $*") \
    -P"${VMKITE_SCP_PORT}" \
    "${VMKITE_SCP_USER}@${VMKITE_SCP_HOST}"
}

export BUILD_DIR=${BUILD_DIR:-/tmp/vmkite-images}
export HASHES_DIR=${BUILD_DIR}/hashes/${BUILDKITE_BRANCH}
export OUTPUT_DIR=${BUILD_DIR}/output/${BUILDKITE_JOB_ID}
export PACKER_CACHE_DIR=$HOME/.packer_cache

image="$1"
sourceimage="${2:-}"
sourcevmx=
sourcehash=

if [[ -n "$sourceimage" ]] ; then
  echo "--- Finding source image for $sourceimage"
  if ! sourcevmx=$(buildkite-agent meta-data get "vmx-${sourceimage}" ) ; then
    echo "+++ Failed to find source vmx for $sourceimage"
  fi
  sourcehash=$(hash_files "$sourcevmx")
  echo "Found $sourcevmx, $sourcehash"
fi

echo "--- Checking if image has been built already"
hashfile="$(get_hash_path "$image" "$sourcehash")"

if [[ -e $hashfile ]] ; then
  vmxfile=$(find_vmx_file "$(readlink "$hashfile")")
  buildkite-agent meta-data set "vmx-${sourceimage}" "$vmxfile"
  echo "Image is already built at $vmxfile"
  exit 0
fi

exit 0

echo "+++ Building $image"
make "$image" \
  "output_directory=$OUTPUT_DIR" \
  "source_path=$sourcevmx"

echo "+++ Uploading $OUTPUT_DIR to sftp"
upload_vm_to_sftp "$OUTPUT_DIR"

if [[ -n "$hashfile" ]] ; then
  echo "--- Linking $OUTPUT_DIR to $hashfile"
  mkdir -p "$(dirname "$hashfile")"
  ln -sf "$OUTPUT_DIR" "$hashfile"
fi