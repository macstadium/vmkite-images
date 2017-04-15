#!/bin/bash
set -eux

cat <<EOF >/etc/network/interfaces.d/ens160;
auto ens160
iface ens160 inet dhcp
EOF