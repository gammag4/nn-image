#!/bin/bash

printf "\nBuilding and installing open3d\n"
set -ev

cd /
git clone https://github.com/isl-org/Open3D --branch v0.19.0
cd Open3D

SUDO=" " util/install_deps_ubuntu.sh assume-yes

mkdir build
cd build
cmake ..

make -j$(nproc)
make install
make install-pip-package

cd /
rm -r Open3D
