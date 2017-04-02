VMKite Images
=============

A set of packer templates and scripts for building base images for use with [vmkite][vmkite].

Building Locally
----------------

Currently these are developed on macOS with VMWare Fusion Pro 8.5+. Get this environment setup, along with packer installed via Homebrew:

```bash
make macos-10.12
make macos-10.11
make macos-10.10
make ubuntu-16.04
```

The packer scripts will upload directly to vSphere. Check out the post-provisioner in the relevant template for more details.

References
----------

- https://github.com/nickcharlton/packer-esxi
- https://github.com/timsutton/osx-vm-templates
- https://github.com/boxcutter/macos
- https://github.com/geerlingguy/packer-ubuntu-1604
- https://github.com/kaoriatz/packer-templates

[vmkite]: https://github.com/macstadium/vmkite
