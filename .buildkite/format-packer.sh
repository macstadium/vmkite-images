#!/bin/bash

sed -E '
  s/^(==>|   ) vmware-(iso|vmx): ?//g;
  s/^(Downloading or copying ISO)/--- :packer: \1/g;
  s/^(Cloning source VM)/--- :packer: \1/g;
  s/^(Provisioning with shell script)/--- :packer: \1/g;
  s/^(Starting virtual machine)/--- :packer: \1/g;
  s/^(Waiting for SSH to become available)/--- :packer: \1/g;
'