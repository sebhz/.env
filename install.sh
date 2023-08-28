#!/bin/bash

# dwm and dwl are a bit special. Do not stow them.
stow -Rv cmus
stow -Rv git
stow -Rv i3
stow -Rv pylint
stow -Rv screen
stow -Rv vim
stow -Rv nvim
stow -Rv wayland
stow -Rv x
stow -Rv clang

if [[ ! -d /etc/stow ]]; then
  sudo mkdir /etc/stow
fi
sudo cp -r interception/etc /etc/stow/interception
pushd /etc/stow
sudo stow -v interception
popd
