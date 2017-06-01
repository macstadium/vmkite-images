#!/bin/bash
set -eux

# aws-cli
apt-get -y install python-pip
pip install --upgrade --user awscli
ln -s /usr/local/bin/aws ~/.local/bin/aws

# jq
apt-get install jq