#!/bin/bash
set -euxo pipefail

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

find_vm_name() {
  find "$1" -iname '*.vmx' -exec basename {} \; | head -n1 | sed 's/\.vmx//'
}

upload_to_sftp() {
  local sourcedir="$1"
  upload_path="$(find_vm_name "$sourcedir")"

  sftp -b <(echo "cd ${VMKITE_SCP_PATH}
     lcd $outputdir
     mkdir $upload_path
     cd $upload_path
     put -r .") \
    -P"${VMKITE_SCP_PORT}" "${VMKITE_SCP_USER}@${VMKITE_SCP_HOST}"
}

image="$1"
filehash="$(get_hash_for_image "$image")"
outputdir=$OUTPUT_DIR

echo "+++ Building $image"

if [[ -n $filehash ]] && [[ -e "$HASHES_DIR/${filehash}" ]] ; then
  outputdir=$(readlink "$HASHES_DIR/${filehash}")
  echo "Image is already built with hash of $filehash, points to $outputdir"
else
  outputdir=$OUTPUT_DIR
fi

if [[ ! -e "$outputdir" ]] ; then
  echo "No build found at $HASHES_DIR/${filehash}"
  make "$@" "output_directory=$outputdir"
fi

echo "+++ Uploading $outputdir to sftp"
upload_to_sftp "$outputdir"

if [[ -n "${filehash}" ]] ; then
  echo "--- Linking hash ${filehash} to ${outputdir}"
  mkdir -p "$HASHES_DIR"
  ln -sf "${HASHES_DIR}/${filehash}" "${outputdir}"
fi