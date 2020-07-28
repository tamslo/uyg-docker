# Dockerfile for Genome Analysis

We created a Docker image for the AYPG lecture so that everybody has the same execution environment and software versions.

## Setup

1. Install Docker (see [Docker documentation](https://docs.docker.com/get-docker/))
2. Run the container:
  ```
  docker run -v <PATH_TO_YOUR_DATA>:/home/aypg-user/data -p 8787:8787 -it --rm tamslo/aypg
  ```
  Note that `<PATH_TO_YOUR_DATA>` needs to be replaced with the absolute path to the data you want to analyze, e.g., `~/Documents/data` on Mac or Linux or `C:/Users/Tamara/Documents/data` on Windows.

## Running Analyzes

The `docker run` command above will start an interactive shell in which you can run tools like `plink` and `plink2`. Your home directory, in which the interactive shell starts, is `/home/aypg-user`. From there, the data you included can be found in the `data` sub-directory. All changes you make in this directory will be mirrored in `<PATH_TO_YOUR_DATA>`.

### RStudio

You can start RStudio with `rstudio-server start` and access it from your browser at http://localhost:8787; sign in with username `aypg-user` and password `1234`.

### Jupyter

You can start Jupyter with `jupyter notebook --ip 0.0.0.0 --no-browser --allow-root`. You can access the tree (from where you started Jupyter) at http://localhost:8888; use the token in the URL you see when starting Jupyter for login. Remember to work somewhere in `/home/aypg-user/data` to store your notebooks.

## Stopping Docker

Before stopping the shell, make sure that **all files and analysis results you want to preserve** should be saved in `/home/aypg-user/data`, which writes the data to your `<PATH_TO_YOUR_DATA>` outside the container on the host system.

To stop the interactive shell just type `exit`.

## Docker Explanation

Explanation of the `docker run` command:
* `-v <PATH_TO_YOUR_DATA>:/home/aypg-user/data` mounts the directory `<PATH_TO_YOUR_DATA>` as a volume, which means that you can read and write in it from the container; in the container it will appear as `/home/aypg-user/data`
* `-p 8787:8787` exposes the port `8787` of the container, on which RStudio runs, to `8787` of the host
* `-it` starts an interactive shell
* `--rm` deletes the container after you close it
* `tamslo/aypg:latest` references the image on [DockerHub](https://hub.docker.com/r/tamslo/aypg)
