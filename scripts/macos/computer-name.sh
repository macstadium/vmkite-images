#!/bin/bash
set -eux

scutil --set ComputerName "vmkite-$(ifconfig en0 | grep 'inet ' | awk '{print $2}' | tr '.' '-')"