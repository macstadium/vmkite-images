#!/bin/bash
set -eux

export GOPATH=$HOME/go

install_golang() {
  sudo add-apt-repository ppa:longsleep/golang-backports
  sudo apt-get update
  sudo apt-get install -y golang-go
}

install_vmkite() {
  echo "Installing vmkite"
  mkdir -p "$HOME/go"
  go get -v github.com/macstadium/vmkite
  sudo ln -snf "$HOME/go/bin/vmkite" /usr/local/bin/
}

install_service() {
  sudo mv "$HOME/vmkite-wrapper.sh" /usr/local/bin/vmkite-wrapper
  sudo chmod +x /usr/local/bin/vmkite-wrapper
  sudo mv "$HOME/vmkite.service" /lib/systemd/system/vmkite.service
  sudo systemctl enable vmkite
}

install_golang
install_vmkite
install_service
