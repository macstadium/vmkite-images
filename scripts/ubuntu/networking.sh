#!/bin/sh -eux

# Not sure why, but when spawned by vmkite, the network interface is ens160
# Suspect this is a variant of the ens33/ens32 issue elsewhere
sed -i "s/ens32/ens160/g" /etc/network/interfaces

# Add delay to prevent "vagrant reload" from failing
echo "pre-up sleep 5" >> /etc/network/interfaces
