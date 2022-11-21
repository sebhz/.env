#!/bin/bash

# dwm and dwl are a bit special. Do not stow them.
stow -v cmus
stow -v git
stow -v i3
stow -v pylint
stow -v screen
stow -v vim
stow -v wayland
stow -v x

if [[ ! -d /etc/stow ]]; then
  sudo mkdir /etc/stow
fi
sudo cp -r interception/etc /etc/stow/interception
pushd /etc/stow
sudo stow -v interception
popd
