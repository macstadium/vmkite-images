#!/bin/bash
set -eux

# This script adds a Mac OS Launch Daemon, which runs on first boot
PLIST=/Library/LaunchDaemons/com.macstadium.set-hostname.plist
cat <<EOF > "${PLIST}"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.github.timsutton.osx-vm-templates.detectnewhardware</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/sbin/networksetup</string>
        <string>-detectnewhardware</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

# This script sets a random hostname
cat <<-EOF > /usr/local/bin/set-random-hostname
#!/bin/bash
set -eu
scutil –-set HostName "$(sed "$(perl -e "print int rand(99999)")q;d" /usr/share/dict/words | awk '{print tolower($0)}')"
EOF

/bin/chmod 644 "${PLIST}" "/usr/local/bin/set-random-hostname"
/usr/sbin/chown root:wheel "${PLIST}" "/usr/local/bin/set-random-hostname"
