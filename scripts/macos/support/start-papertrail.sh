#!/bin/bash
set -eu

ipaddress="$(ifconfig en0 | awk '/inet / {print $2}' | sed 's/\./-/g')"

scutil --set HostName "vmkite-${ipaddress}"
scutil --set LocalHostName "vmkite-${ipaddress}"
scutil --set ComputerName "vmkite-${ipaddress}"

exec /usr/local/bin/remote_syslog -D
