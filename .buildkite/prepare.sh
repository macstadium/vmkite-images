#!/bin/bash
set -euo pipefail

macos_release="$1"
cache_dir="/usr/local/var/buildkite-agent/cache"
installer_app="/Applications/Install macOS Sierra.app"

prepare_hash() {
	find prepare_iso/ -type f -print0 \
		| xargs -0 shasum | awk '{print $1}' | sort | shasum | awk '{print $1}'
}

installer_app_hash() {
	shasum "${installer_app}/Contents/SharedSupport/InstallESD.dmg" | awk '{print $1}'
}

echo "--- Checking hash of ${installer_app}"
installer_hash_parts=($(prepare_hash) $(installer_app_hash))
installer_hash=$(echo ${installer_hash_parts[*]} | shasum | awk '{print $1}')
echo "Hash is ${installer_hash}"

installer_cache_path="${cache_dir}/installers/${installer_hash}"
installer_dir="$installer_cache_path"

if [[ -d "$installer_cache_path" ]] ; then
	echo "Installer is in cache already, skipping building"
else
	echo "--- Preparing installer for ${macos_release}"
	sudo prepare_iso/prepare_iso.sh "/Applications/Install ${macos_release}.app" "$installer_dir"
fi

buildkite-agent meta-data set installer_path "$(ls -1 $installer_dir/OSX_InstallESD_*)"