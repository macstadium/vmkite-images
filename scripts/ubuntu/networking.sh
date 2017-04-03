#!/bin/sh -eux

# Add delay to prevent "vagrant reload" from failing
echo "pre-up sleep 5" >> /etc/network/interfaces
