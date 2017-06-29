#!/bin/bash
set -e

vmware-rpctool() {
  /Library/Application\ Support/VMware\ Tools/vmware-tools-daemon --cmd "$1"
}

vmware-log() {
  vmware-rpctool "log ${1}"
}

customize-child-vm() {
  # We're in the child now. Let's Perform basic customization.
  vmware-log "End of fork; begin customization"
  mac_address=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')

  # Bring back up ethernet
  # ifconfig en0 ether "$(vmware-rpctool "info-get guestinfo.fork.ethernet0.address")"

  ifconfig en0 ether "$mac_address"
  ifconfig en0 up

  # ip link set dev eth0 address "$(vmware-rpctool "info-get guestinfo.fork.ethernet0.address")"
  # ip link set dev eth0 up

  # It might be necessary to release/renew the IP address.
  ipconfig set en0 DHCP

  # dhclient -r -v eth0 && rm /var/lib/dhcp/dhclient.* ; dhclient -v eth0

  # Perhaps configure an ip address using CreateChildSpec.
  # ifconfig eth0 `vmware-rpctool "info-get guestinfo.fork.ip0.address"` netmask 255.255.255.0 up

  # Configure a host name using CreateChildSpec.
  # oldname=`hostname`
  # The name gets set in the VM's extraConfig, which can be queried.
  # newname=`vmware-rpctool "info-get guestinfo.fork.hostname"`
  # hostname $newname
  # bash -c "echo $newname > /etc/hostname"
  # PS1="[\d \t \u@\h:\w ] $ "
  # sed -i "s/$oldname/$newname/g" /etc/hosts

  vmware-log "End of customization"
}

vmware-log "Downing network"
ifconfig en0 down

if vmware-rpctool "vmfork-begin -1 -1" > /dev/null ; then
  customize-child-vm
fi
