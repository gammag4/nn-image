FROM nvcr.io/nvidia/pytorch:25.02-py3
COPY . /code/
RUN /code/install_ffmpeg.sh
RUN pip install -r /code/requirements.txt
# ENTRYPOINT bash
CMD jupyter notebook --ip 0.0.0.0

# docker build -t torch -f Dockerfile
# docker run -it --gpus all -d --name torch nvcr.io/nvidia/pytorch:25.02-py3
# docker start torch
# docker exec -it torch bash
