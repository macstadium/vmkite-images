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

  if [[ -n "${filehash}" ]] ; then
    echo "Linking hash of ${filehash} to ${outputdir}"
    mkdir -p "$HASHES_DIR"
    ln -sf "${HASHES_DIR}/${filehash}" "${outputdir}"
  fi
fi

vm_name=$(find "$outputdir" -iname '*.vmx' -exec basename {} \; | head -n1 | sed 's/\.vmx//')
upload_path="${VMKITE_SCP_PATH}/${vm_name}"
sftp_script=$(cat <<KITTENS
mkdir $upload_path
cd $upload_path
put -ra .
KITTENS
)

cd "$outputdir"
echo "+++ Uploading $outputdir to $upload_path"
sftp -b <(echo "$sftp_script") \
  -P"${VMKITE_SCP_PORT}" "${VMKITE_SCP_USER}@${VMKITE_SCP_HOST}"