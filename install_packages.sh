#!/bin/bash

printf "\nInstalling initial packages\n"
set -ev

apt-get update
apt-get -y install unminimize
yes | unminimize
apt-get -y install ccache \
  man \
  neovim
