#!/bin/bash

printf "\nBuilding and installing ffmpeg\n"
set -ev

cd /

git clone https://github.com/FFmpeg/nv-codec-headers.git --branch n13.0.19.0
cd nv-codec-headers && make install
cd /
rm -r nv-codec-headers

# TODO add versions for better reproducibility
apt-get update
apt-get -y install build-essential yasm cmake libtool libc6 libc6-dev unzip wget libnuma1 libnuma-dev

git clone https://github.com/FFmpeg/FFmpeg.git --branch n7.1.1 ffmpeg/
cd ffmpeg/
./configure --enable-nonfree --enable-cuda-nvcc --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --disable-static --enable-shared
make -j 8
make install
cd /
rm -r ffmpeg

echo "/usr/local/lib" > /etc/ld.so.conf.d/usr-local.conf
ldconfig
