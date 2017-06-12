#!/bin/bash

apt-get install -y nfs-kernel-server portmap

mkdir /var/nfs/
chown nobody:nogroup /var/nfs

echo "/var/nfs *(rw,sync,no_subtree_check)" >> /etc/exports
exportfs -a