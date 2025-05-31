# NN Image

Just an image I use to develop Python projects in VSCode.

### Building image

Prerequisites for building:

- [Docker](https://docs.docker.com/engine/install/)
- [NVIDIA Drivers](https://github.com/roworu/nvidia-fedora-secureboot)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

Before building, you should get an API key from [NVIDIA NGC Website](https://org.ngc.nvidia.com/setup/api-keys), then run `docker login nvcr.io` and use `$oauthtoken` as user and your API key as password.

To build image, run:

```sh
docker build -t torch .
```

### Running container

To create and run container, use:

```sh
docker run -it -v /<host-project-folder>/:/home/ubuntu/<target-project-folder>/ -e NVIDIA_DRIVER_CAPABILITIES=all --gpus 'all' -d --name torch torch
docker start torch
```

To execute a new shell in the container, use:

```sh
docker exec -it torch bash
```

or, if you need to run as root (e.g. for installing packages), run a new shell using:

```sh
docker exec -u root -it torch bash
```

### Integrating with VSCode

To use it with VSCode, open command palette (`ctrl+shift+p`), choose `Dev Containers: Attach to Running Container...`, choose `torch` container in the list and open the project folder in the new VSCode window.
