# Check https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch/tags 24.12 is the latest stable
FROM nvcr.io/nvidia/pytorch:24.12-py3
COPY . /code/
RUN chmod -R +x /code/
RUN /code/git_configs.sh
RUN /code/install_ffmpeg.sh
RUN pip install -r /code/requirements.txt
ENTRYPOINT bash
# CMD jupyter notebook --ip 0.0.0.0

# docker build -t torch -f Dockerfile --progress=plain . &> build.log
# docker run -it --gpus all -d --name torch nvcr.io/nvidia/pytorch:24.12-py3
# docker run -it -v ~/Projects/:/Projects/ --gpus all -d --name torch torch
# docker start torch
# docker exec -it torch bash
