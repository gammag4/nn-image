# You should have NVIDIA Drivers and NVIDIA Container Toolkit installed before building, see README.md for details.

# Check tags in https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch/tags
# Check release notes in https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/index.html
# 24.12 is the latest with cuda 12.6 and python 3.12, based in ubuntu 24.04
# Versions: cuda 12.6, python 3.12, pytorch 2.7.0+cu126
# If updating to another container, check `install_open3d.sh` to update it if needed
FROM nvcr.io/nvidia/pytorch:24.12-py3
#TODO Add versions when installing packages in scripts for better reproducibility
COPY . /code
WORKDIR /code
RUN rm -r /workspace
RUN chmod -R +x .

RUN ./install_packages.sh
RUN ./install_ffmpeg.sh
RUN pip install -r requirements.txt
RUN ./install_open3d.sh

RUN chown -R ubuntu:ubuntu /code
USER ubuntu

WORKDIR /home/ubuntu
RUN rm -r /code
ENTRYPOINT bash
# CMD jupyter notebook --ip 0.0.0.0

# docker build -t torch .
# docker build -t torch -f Dockerfile --progress=plain . &> build.log
# docker run -it -v ~/Desktop/Projects/:/home/ubuntu/Projects/ -v ~/.ssh/:/home/ubuntu/.ssh/ -e NVIDIA_DRIVER_CAPABILITIES=all --gpus 'all' -d --name torch torch
# docker start torch
# docker exec -it torch bash
# docker exec -u root -it torch bash
