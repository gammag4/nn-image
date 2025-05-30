#!/bin/bash

printf "\nBuilding and installing open3d\n"
set -ev

cd /
git clone https://github.com/isl-org/Open3D --branch v0.19.0
git clone https://github.com/isl-org/Open3D-ML --branch v0.19.0
cd Open3D
git submodule update --init --recursive

apt-get install -y npm
npm install -g yarn

SUDO=" " util/install_deps_ubuntu.sh assume-yes
pip install -r python/requirements_jupyter_build.txt

sed -i -e "/^#ifndef THRUST_IGNORE_CUB_VERSION_CHECK$/i #define THRUST_IGNORE_CUB_VERSION_CHECK" usr/local/cuda/targets/x86_64-linux/include/thrust/system/cuda/config.h

mkdir build
cd build

# If you're updating the container, check if GLIBCXX_USE_CXX11_ABI should be ON or OFF running `python -c "import torch; print(torch._C._GLIBCXX_USE_CXX11_ABI)"`
cmake -DBUILD_JUPYTER_EXTENSION=ON \
      -DBUILD_CUDA_MODULE=ON \
      -DGLIBCXX_USE_CXX11_ABI=ON \
      -DBUILD_PYTORCH_OPS=ON \
      -DBUNDLE_OPEN3D_ML=ON \
      -DOPEN3D_ML_ROOT=/Open3D-ML/ \
      ..

make -j$(nproc)
make install -j$(nproc)
make install-pip-package -j$(nproc)

cd /
rm -r Open3D
rm -r Open3D-ML
