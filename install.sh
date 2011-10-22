#!/bin/bash

cd $HOME
mkdir .config

ln -s .env/awesome .config/awesome
ln -s .env/i3 .config/i3
ln -s .env/i3status/.i3status.conf .
ln -s .env/notion .notion
ln -s .env/vim/.vim .
ln -s .env/vim/.vimrc .
ln -s .env/bash/.bashrc .

