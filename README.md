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

Configuring Bas Images
----------------------

All of the images provided read configuration from VMWare. The following keys are read currently:

| Key                          | Description                             |
|------------------------------|-----------------------------------------|
| vmkite-vmdk                  | The vmdk file this VM was lauched with  |
| vmkite-name                  | The name for the buildkite agent        |
| vmkite-buildkite-agent-token | The agent token for buildkite           |

These keys are currently passed to the buildkite-agent which starts up on image boot.

Supported Images
----------------

### macOS 

The macOS images are for testing darwin and ios. They include:

* XCode Commandline Tools
* Buildkite Agent (v3)
* SSH

A vmkite user is created and used, with a password of `vmkite`.


```bash
make macos-10.12
make macos-10.11
make macos-10.10
```

### Linux

Currently Ubuntu images are provided, with the following extras installed:

* Buildkite Agent (v3)
* SSH

A vmkite user is created and used, with a password of `vmkite`.

```
make ubuntu-16.04
```

### VMKite 

This provides a ubuntu image to run [vmkite][vmkite], which listens for builds from buildkite.com and spawns the above images.

```
make vmkite-agent
```

This image also reads the following params from VMWare's guestinfo for configuration:

 * `vmkite-buildkite-agent-token`
 * `vmkite-buildkite-api-token`
 * `vmkite-buildkite-org`
 * `vmkite-source-datastore` (default PURE1-1)
 * `vmkite-target-datastore` (default PURE1-1)
 * `vmkite-cluster-path` (default '/MacStadium - Vegas/host/XSERVE_Cluster')
 * `vmkite-vm-memory` (default 4096)
 * `vmkite-vm-network-label` (default dvPortGroup-Private-1)
 * `vmkite-vm-num-cpus` (default 2)
 * `vmkite-vm-path` (default '/MacStadium - Vegas/vm')

References
----------

- https://github.com/nickcharlton/packer-esxi
- https://github.com/timsutton/osx-vm-templates
- https://github.com/boxcutter/macos
- https://github.com/geerlingguy/packer-ubuntu-1604
- https://github.com/kaoriatz/packer-templates

[vmkite]: https://github.com/macstadium/vmkite
