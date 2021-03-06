VMKite Images
=============

A set of packer templates and scripts for building base images for use with [vmkite][vmkite].

These base images will boot a buildkite-agent process on boot with specific metadata that matches a job spawned by [vmkite][vmkite].

Building Locally
----------------

Currently these are developed on macOS with VMWare Fusion Pro 8.5+. Get this environment setup, along with packer installed via Homebrew:

```
brew cask install vmware-fusion
brew install packer
```


Images
------

_Base images_ are built for macOS and Ubuntu Linux with packer's `vmware-iso` builder.

These are then customized into _Agent images_ using the `vmware-vmx` builder to produce images with the `buildkite-agent` on them, along with customizations for `vmkite`.

Configuring Agent Images
------------------------

Agent images read from VMWare via the [guestinfo](https://www.vmware.com/support/developer/converter-sdk/conv55_apireference/vim.vm.GuestInfo.html) keys. The following keys are read currently in the form of `guestinfo.{key}`:

| Key                          | Description                             |
|------------------------------|-----------------------------------------|
| vmkite-vmdk                  | The vmdk file this VM was lauched with  |
| vmkite-name                  | The name for the buildkite agent        |
| vmkite-buildkite-agent-token | The agent token for buildkite           |
| vmkite-buildkite-debug       | Whether to enable debug mode            |
| aws-access-key-id            | An AWS Access Key ID                    |
| aws-secret-access-key        | An AWS Secret Access Key                |

These keys are currently passed to the buildkite-agent which starts up on image boot.

Image Contents
--------------

### macOS 10.12

The macOS images are for testing darwin and ios. They include:

* XCode Commandline Tools
* Buildkite Agent (v3)
* SSH
* aws-cli (for downloading hooks and secrets)

A vmkite user is created and used, with a password of `vmkite`.


```bash
make macos-10.12
```

### Ubuntu Linux 16.04

Currently Ubuntu images are provided, with the following extras installed:

* Buildkite Agent (v3)
* SSH
* aws-cli (for downloading hooks and secrets)

A vmkite user is created and used, with a password of `vmkite`.

```
make ubuntu-16.04
```

### VMKite 

This provides a ubuntu image to run [vmkite][vmkite], which listens for builds from buildkite.com and spawns the above images.

```
make vmkite
```

This image also reads the following params from VMWare's `guestinfo` for configuration:

 * `guestinfo.vmkite-buildkite-agent-token`
 * `guestinfo.vmkite-buildkite-api-token`
 * `guestinfo.vmkite-buildkite-org`
 * `guestinfo.vmkite-buildkite-debug`
 * `guestinfo.vmkite-source-datastore` 
 * `guestinfo.vmkite-target-datastore` 
 * `guestinfo.vmkite-cluster-path` 
 * `guestinfo.vmkite-vm-memory` (default 4096)
 * `guestinfo.vmkite-vm-network-label` 
 * `guestinfo.vmkite-vm-num-cpus` 
 * `guestinfo.vmkite-vm-path` 
 * `guestinfo.vmkite-vsphere-host`
 * `guestinfo.vmkite-vsphere-user`
 * `guestinfo.vmkite-vsphere-pass`
 * `guestinfo.vmkite-vsphere-insecure` (default 'true')

References
----------

- https://github.com/nickcharlton/packer-esxi
- https://github.com/timsutton/osx-vm-templates
- https://github.com/boxcutter/macos
- https://github.com/geerlingguy/packer-ubuntu-1604
- https://github.com/kaoriatz/packer-templates

[vmkite]: https://github.com/macstadium/vmkite
