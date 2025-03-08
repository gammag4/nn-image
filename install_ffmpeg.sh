#!/bin/bash
cd /

git clone https://github.com/FFmpeg/nv-codec-headers.git
cd nv-codec-headers && make install
cd /
rm -r nv-codec-headers

apt-get update
apt-get install build-essential yasm cmake libtool libc6 libc6-dev unzip wget libnuma1 libnuma-dev

git clone https://github.com/FFmpeg/FFmpeg.git ffmpeg/
cd ffmpeg/
./configure --enable-nonfree --enable-cuda-nvcc --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --disable-static --enable-shared
make -j 8
make install
cd /
rm -r ffmpeg

echo "/usr/local/lib" > /etc/ld.so.conf.d/usr-local.conf
ldconfig
