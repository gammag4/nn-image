#!/bin/bash

printf "\nInstalling open3d\n"
set -ev

apt-get install -y npm
npm install -g yarn

apt-get install -y libegl1 libgl1 libgomp1
SUDO=" " ./open3d_install_deps_ubuntu.sh assume-yes
pip install ipywidgets jupyter_packaging configargparse dash flask

pip install open3d==0.19
