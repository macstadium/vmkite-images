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

Uploading to vSphere Datastore
------------------------------

Use `ovftool` to upload the created vmx to the datastore:

```bash
VMX_PATH=output/ubuntu-16.04-amd64/ubuntu-16.04-amd64.vmx
VM_NAME=vmkite-my-test-vm
VSPHERE_DATASTORE=PURE_1_1
VSPHERE_NETWORK=MY_NETWORK
VSPHERE_USERNAME=admin%40example.org
VSPHERE_PASSWORD=llamas
VSPHERE_HOST=10.92.x.x
VSPHERE_DATACENTER="MacStadium - Vegas"
VSPHERE_CLUSTER="XSERVE_Cluster"

ovftool \
  --acceptAllEulas \
  --name="$VM_NAME" \
  --datastore="$VSPHERE_DATASTORE" \
  --noSSLVerify=true \
  --diskMode=thin \
  --vmFolder=/ \
  --network="$VSPHERE_NETWORK" \ 
  --X:logLevel=verbose \
  "$VMX_PATH" \
  "vi://${VSPHERE_USERNAME}:${VSPHERE_PASSWORD}@${VSPHERE_HOST}/${VSPHERE_DATACENTER}/host/${VSPHERE_CLUSTER}"
```

References
----------

- https://github.com/nickcharlton/packer-esxi
- https://github.com/timsutton/osx-vm-templates
- https://github.com/boxcutter/macos
- https://github.com/geerlingguy/packer-ubuntu-1604
- https://github.com/kaoriatz/packer-templates

[vmkite]: https://github.com/macstadium/vmkite
