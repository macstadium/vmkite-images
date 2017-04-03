#!/bin/sh -eux

UBUNTU_VERSION=$(lsb_release -sr)
if [ "${UBUNTU_VERSION}" = 16.04 ] || [ "${UBUNTU_VERSION}" = 16.10 ] ; then
    # from https://github.com/cbednarski/packer-ubuntu/blob/master/scripts-1604/vm_cleanup.sh#L9-L15
    # When booting with Vagrant / VMware the PCI slot is changed from 33 to 32.
    # Instead of eth0 the interface is now called ens33 to mach the PCI slot,
    # so we need to change the networking scripts to enable the correct
    # interface.
    #
    # NOTE: After the machine is rebooted Packer will not be able to reconnect
    # (Vagrant will be able to) so make sure this is done in your final
    # provisioner.
    sed -i "s/ens33/ens32/g" /etc/network/interfaces
fi

# Add delay to prevent "vagrant reload" from failing
echo "pre-up sleep 2" >> /etc/network/interfaces
