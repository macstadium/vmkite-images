#!/bin/bash
set -eux

# This script adds a Mac OS Launch Daemon, which runs on first boot
PLIST=/Library/LaunchDaemons/com.macstadium.vmkite.set-random-hostname.plist
cat << EOF > "${PLIST}"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.macstadium.vmkite.set-random-hostname</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/set-random-hostname</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

mkdir -p /usr/local/bin
cp /private/tmp/set-random-hostname.sh /usr/local/bin/set-random-hostname

/bin/chmod 644 "${PLIST}"
/bin/chmod 755 /usr/local/bin/set-random-hostname
