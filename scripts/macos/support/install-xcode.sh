#!/bin/bash
set -euxo pipefail

if [ -z "${XCODE_CACHE_DIR}" ] ; then
  echo "Must set \$XCODE_CACHE_DIR"
  exit 1
fi

version="$1"
app_dir="/Applications/Xcode-${version}.app"
tar_file="${XCODE_CACHE_DIR}/${version}.tar"

if [ ! -d "$app_dir" ] ; then
  xcversion install "$version"
fi

if [ ! -f "$tar_file" ] ; then
  tar cf "$tar_file" "$app_dir"
fi

ls -al "$tar_file"