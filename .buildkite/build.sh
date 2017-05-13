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

  filehash="$(hash_files "${files[@]}")"
  imagehash="$(echo "$filehash $sourcehash" | hash_strings)"

  echo "$HASHES_DIR/$image/${imagehash}"
}

find_vmx_file() {
  find "$1" -iname '*.vmx' | head -n1
}

upload_vmx() {
  local vmx_path="$1"
  local vm_name=$(basename "$vmx_path" | sed 's/\.vmx//')

  echo "+++ Uploading $vmx_path to ${VSPHERE_DATACENTER}:/${vm_name}"
  ovftool \
    --acceptAllEulas \
    --name="$vm_name" \
    --datastore="$VSPHERE_DATASTORE" \
    --noSSLVerify=true \
    --diskMode=thin \
    --vmFolder=/ \
    --network="$VSPHERE_NETWORK" \
    --X:logLevel=verbose \
    --overwrite \
    "$vmx_path" \
    "vi://${VSPHERE_USERNAME}:${VSPHERE_PASSWORD}@${VSPHERE_HOST}/${VSPHERE_DATACENTER}/host/${VSPHERE_CLUSTER}"
}

export BUILD_DIR=${BUILD_DIR:-/tmp/vmkite-images}
export HASHES_DIR=${BUILD_DIR}/hashes
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
echo "$hashfile"

if [[ -e $hashfile ]] ; then
  vmxfile=$(find_vmx_file "$(readlink "$hashfile")")
  buildkite-agent meta-data set "vmx-${image}" "$vmxfile"
  echo "Image is already built at $vmxfile"
  exit 0
fi

echo "+++ Building $image"
make "$image" \
  "output_directory=$OUTPUT_DIR" \
  "source_path=$sourcevmx"

ls -alh "$OUTPUT_DIR"
vmxfile=$(find_vmx_file "$OUTPUT_DIR")
buildkite-agent meta-data set "vmx-${image}" "$vmxfile"

echo "+++ Uploading $vmxfile to vsphere"
upload_vmx "$vmxfile"

if [[ -n "$hashfile" ]] ; then
  echo "--- Linking $OUTPUT_DIR to $hashfile"
  mkdir -p "$(dirname "$hashfile")"
  ln -sf "$OUTPUT_DIR" "$hashfile"
fi