# ISO preparer for macOS

This is a script derived from https://github.com/timsutton/osx-vm-templates for preparing a macOS installer file for unattended installation and customization with Packer. 

Currently supporter macOS versions are: El Capitan (10.11) and macOS Sierra (10.12).

## Getting Started

Run the `prepare_iso.sh` script with two arguments: the path to an `Install OS X.app` or the `InstallESD.dmg` contained within, and an output directory. Root privileges are required in order to write a new DMG with the correct file ownerships. For example:

```bash
sudo prepare_iso/prepare_iso.sh "/Applications/Install macOS Sierra.app/" installers
```

`prepare_iso.sh` accepts command line switches to modify the details of the admin user installed by the script.

* `-u` modifies the name of the admin account, defaulting to `vagrant`
* `-p` modifies the password of the same account, defaulting to `vagrant`
* `-i` sets the path of the account's avatar image, defaulting to `prepare_iso/support/vagrant.jpg`

For example:

`sudo prepare_iso/prepare_iso.sh -u admin -p password -i /path/to/image.jpg "/Applications/Install OS X Mountain Lion.app" out`

Additionally, flags can be set to disable certain default configuration options.

* `-D DISABLE_REMOTE_MANAGEMENT` disables the Remote Management service.
* `-D DISABLE_SCREEN_SHARING` disables the Screen Sharing service.

