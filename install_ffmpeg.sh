#!/bin/bash

printf "\nBuilding and installing ffmpeg\n"
set -ev

mkdir /ffmpeg_sources/

# TODO add versions for better reproducibility
apt-get -y install \
  autoconf \
  automake \
  build-essential \
  cmake \
  git-core \
  libass-dev \
  libfreetype6-dev \
  libgnutls28-dev \
  libmp3lame-dev \
  libsdl2-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  meson \
  ninja-build \
  pkg-config \
  texinfo \
  wget \
  yasm \
  zlib1g-dev \
  libc6 \
  libc6-dev \
  unzip \
  libnuma1 \
  libnuma-dev \
  libunistring-dev \
  libaom-dev \
  nasm \
  libx264-dev \
  libx265-dev \
  libvpx-dev \
  libfdk-aac-dev \
  libopus-dev \
  libdav1d-dev

# libaom
cd /ffmpeg_sources/ && \
  git -C aom pull 2> /dev/null || git clone --depth 1 https://aomedia.googlesource.com/aom && \
  mkdir -p aom_build && \
  cd aom_build && \
  cmake -G "Unix Makefiles" -DENABLE_TESTS=OFF -DENABLE_NASM=ON ../aom && \
  make -j$(nproc) && \
  make install

# libsvtav1
cd /ffmpeg_sources/ && \
  git -C SVT-AV1 pull 2> /dev/null || git clone https://gitlab.com/AOMediaCodec/SVT-AV1.git --branch v2.3.0 && \
  mkdir -p SVT-AV1/build && \
  cd SVT-AV1/build && \
  cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DBUILD_DEC=OFF -DBUILD_SHARED_LIBS=ON .. && \
  make -j$(nproc) && \
  make install

# libvmaf
cd /ffmpeg_sources/ && \
  git clone 'https://github.com/Netflix/vmaf' 'vmaf-master' && \
  mkdir -p 'vmaf-master/libvmaf/build' && \
  cd 'vmaf-master/libvmaf/build' && \
  meson setup -Denable_tests=false -Denable_docs=false --buildtype=release --default-library=shared '../' && \
  ninja -j$(nproc) && \
  ninja install

# NVIDIA codecs
cd /ffmpeg_sources/
git clone https://github.com/FFmpeg/nv-codec-headers.git --branch n13.0.19.0
cd nv-codec-headers && make install

# ffmpeg
cd /ffmpeg_sources/
git clone https://github.com/FFmpeg/FFmpeg.git --branch n7.1.1 ffmpeg/
cd ffmpeg/
./configure \
  --extra-libs="-lpthread -lm" \
  --ld="g++" \
  --enable-gpl \
  --enable-nonfree \
  --enable-gnutls \
  --enable-libass \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libvorbis \
  --enable-libx264 \
  --enable-libx265 \
  --enable-libvpx \
  --enable-libfdk-aac \
  --enable-libopus \
  --enable-libaom \
  --enable-libsvtav1 \
  --enable-libdav1d \
  --enable-libvmaf \
  --enable-cuda-nvcc \
  --enable-libnpp \
  --extra-cflags=-I/usr/local/cuda/include \
  --extra-ldflags=-L/usr/local/cuda/lib64 \
  --disable-static \
  --enable-shared
make -j$(nproc)
make install
cd /
rm -r /ffmpeg_sources/

echo "/usr/local/lib" > /etc/ld.so.conf.d/usr-local.conf
ldconfig
