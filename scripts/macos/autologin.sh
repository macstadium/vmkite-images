#!/bin/bash
set -eux

echo "Enabling automatic GUI login for the '$USERNAME' user.."

python /private/tmp/set_kcpassword.py "$PASSWORD"

/usr/bin/defaults write /Library/Preferences/com.apple.loginwindow autoLoginUser "$USERNAME"

echo "Disabling screensaver.."

/usr/bin/defaults -currentHost write com.apple.screensaver idleTime 0

echo "Disabling sleep.."

pmset -a sleep 0