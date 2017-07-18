#!/bin/bash
set -eu

# Remove un-used stuff
rm -rf "/Library/Screen Savers"
rm -rf "/Library/Updates"
rm -rf "/Library/Desktop Pictures"

# Turn off hibernation and get rid of the sleepimage
pmset hibernatemode 0
rm -f /var/vm/sleepimage

# Stop the pager process and drop swap files. These will be re-created on boot.
# Starting with El Cap we can only stop the dynamic pager if SIP is disabled.
if csrutil status | grep -q disabled; then
    launchctl unload /System/Library/LaunchDaemons/com.apple.dynamic_pager.plist
    sleep 5
fi
rm -rf /private/var/vm/swap*

# Zero out empty space
slash="$(df -h / | tail -n 1 | awk '{print $1}')"
echo Zeroing out free space
diskutil secureErase freespace 0 ${slash}

# Shrink the disk
/Library/Application\ Support/VMware\ Tools/vmware-tools-cli disk shrink /
