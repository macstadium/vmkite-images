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

# This script sets a random hostname
SCRIPT=/usr/bin/set-random-hostname
cat << 'SCRIPT_EOF' > "${SCRIPT}"
#!/bin/bash
set -eu
RANDOM_WORDS="$(sed "$(perl -e "print int rand(99999)")q;d" /usr/share/dict/words | awk '{print tolower($0)}')"
scutil –-set HostName "vmkite-${RANDOM_WORDS}"
SCRIPT_EOF

/bin/chmod 644 "${PLIST}" "${SCRIPT}"
/usr/sbin/chown root:wheel "${PLIST}" "${SCRIPT}"
