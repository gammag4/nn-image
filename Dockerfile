# You should have NVIDIA drivers and CUDA Toolkit installed before building, see README.md for details.

# Check tags in https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch/tags
# Check release notes in https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/index.html
# 24.12 is the latest with cuda 12.6 and python 3.12, based in ubuntu 24.04
FROM nvcr.io/nvidia/pytorch:24.12-py3
RUN apt-get update
RUN apt-get -y install ccache
COPY . /code/
RUN chmod -R +x /code/
RUN /code/git_configs.sh
RUN /code/install_ffmpeg.sh
RUN /code/install_open3d.sh
RUN pip install -r /code/requirements.txt
RUN rm -r /code/
ENTRYPOINT bash
# CMD jupyter notebook --ip 0.0.0.0

# use "$oauthtoken" as user and api key from https://org.ngc.nvidia.com/setup/api-keys as password
# docker login nvcr.io
# sudo docker build -t torch -f Dockerfile .
# sudo docker build -t torch -f Dockerfile --progress=plain . &> build.log
# sudo docker run -it -v ~/Projects/:/Projects/ --gpus all -d --name torch torch

# docker run -it --gpus all -d --name torch nvcr.io/nvidia/pytorch:24.12-py3
# docker start torch
# docker exec -it torch bash
