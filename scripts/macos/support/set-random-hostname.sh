#!/bin/bash
set -eu
RANDOM_WORDS="$(sed "$(perl -e "print int rand(99999)")q;d" /usr/share/dict/words | awk '{print tolower($0)}')"
scutil --set HostName "vmkite-${RANDOM_WORDS}"
