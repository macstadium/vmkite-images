#!/bin/bash
set -euo pipefail

HASHES_DIR=/tmp/output-hashes/${BUILDKITE_BRANCH}
OUTPUT_DIR=${OUTPUT_DIR:-/tmp/output}

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
  echo "Skipping image build, already exists"
  exit 0
fi

make "$@" "output_directory=$OUTPUT_DIR"

if [[ -n "${filehash}" ]] ; then
  echo "Writing hash of ${filehash}"
  mkdir -p "$HASHES_DIR"
  touch "${HASHES_DIR}/${filehash}"
fi