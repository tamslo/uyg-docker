# Dockerfile for Genome Analysis

We created a Docker image for the UYG lecture so that everybody has the same execution environment and software versions.

## Setup

1. **Install Docker** (see [Docker documentation](https://docs.docker.com/get-docker/))

2. **Start** the container:
  ```
  docker run -v $PATH_TO_YOUR_DATA:/home/uyg-user/data -p 8787:8787 -p 8888:8888 -it --rm tamslo/uyg
  ```
  Note that `$PATH_TO_YOUR_DATA` needs to be replaced with the absolute path to the data you want to analyze, e.g., `~/Documents/data` on Mac or Linux or `C:/Users/Tamara/Documents/data` on Windows.

  For more information regarding the Docker command, please refer to the section [Docker Explanation](#docker-explanation).

3. **Run analyses** inside the container as described [below](#run-analyzes)

4. **Stop** the container:

  Before stopping, make sure that **all files and analysis results you want to preserve** should be saved in `/home/uyg-user/data`, which writes the data to your `PATH_TO_YOUR_DATA` outside the container on the host system.

  To stop the interactive shell just type `exit`.


For advanced usage see the sections [Customizing](#customizing) and [Updating](#updating).

## Run Analyses

The `docker run` command above will start an interactive shell in which you can run tools like `plink` and `plink2`.

Your home directory, in which the interactive shell starts, is `/home/uyg-user`. From there, the data you included with `-v` can be found in the `data` subdirectory. All changes you make in this directory will be mirrored in `PATH_TO_YOUR_DATA`.

### RStudio

You can start RStudio with `rstudio-server start` and access it from your browser at http://localhost:8787; sign in with username `uyg-user` and password `1234`.

### Jupyter

You can start Jupyter with `jupyter notebook --ip 0.0.0.0 --no-browser --allow-root`. You can access it at http://localhost:8888; use the token in the URL you see in the shell when starting Jupyter for login.

## Customizing

We provide you with some basic tools, but if you feel like you need more you can of course install them inside your container.

To create an adapted version of the provided Docker container, omit the `--rm` flag when starting your container and adapt the container in the interactive shell (for exmaple, install other tools using `apt-get`).

After exiting the container, get its `CONTAINER_ID` with `docker ps -a` and save the container state to a new image with `docker commit $CONTAINER_ID $IMAGE_NAME`.
To start a container replace the image name `tamslo/uyg` in the command above with `$IMAGE_NAME`.

If you think the tools you installed should be available for everybody, please either contact Tamara (tamara.slosarek@hpi.de) or adapt the Dockerfile and create a pull request on [GitHub](https://github.com/tamslo/uyg-docker).

## Updating

When pulling the `tamslo/uyg` image the first time, a local copy is created that is not automatically updated. To update your image in case of changes, run `docker pull tamslo/uyg`.

To check whether there is a newer version, compare the digest of your local image, which you can get with `docker images --digests`, with the digest you see on [DockerHub](https://hub.docker.com/r/tamslo/uyg/tags).

## Docker Explanation

Explanation of the `docker run` command:
* `-v <PATH_TO_YOUR_DATA>:/home/uyg-user/data` mounts the directory `<PATH_TO_YOUR_DATA>` as a volume, which means that you can read and write in it from the container; in the container it will appear as `/home/uyg-user/data`
* `-p 8787:8787` exposes the port `8787` of the container, on which RStudio runs, to `8787` of the host
* `-it` starts an interactive shell
* `--rm` deletes the container after you close it
* `tamslo/uyg:latest` references the image on [DockerHub](https://hub.docker.com/r/tamslo/uyg)

## Troubleshooting

**docker: Error response from daemon: driver failed programming external connectivity on endpoint** [...]**: Bind for 0.0.0.0:$PORT** **failed: port is already allocated.**

Docker cannot bind the port `$PORT` because it already is used. This message either means (1) that you already have a container running or (2) that another service is using `$PORT`.

(1) Run `docker ps` to see running containers. If a container is already running on port `$PORT` you can stop it with `docker stop $CONTAINER_ID`.

(2) If you do not want to stop the container or program using port `$PORT`, you can change the ports the container binds to. for example instead of binding RStudio to `8787`, try `9797` by using `-p 9797:8787` in the start command. RStudio will then be available on `http://localhost:9797`.
