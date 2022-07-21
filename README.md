# Dockerfile for Genome Analysis

We created a Docker image for the UYG lecture so that everybody has the same execution environment and software versions. For questions and suggestions please contact Tamara (tamara.slosarek@hpi.de) or adapt the Dockerfile and create a pull request on [GitHub](https://github.com/tamslo/uyg-docker).

## Setup

1. **Install Docker** (see [Docker documentation](https://docs.docker.com/get-docker/)).

2. **Start** the container:
   ```
   docker run -v $PATH_TO_YOUR_DATA:/home/uyg-user/data -p 8787:8787 -p 8888:8888 -it --rm tamslo/uyg
   ```
   Note that `$PATH_TO_YOUR_DATA` needs to be replaced with the absolute path to the data you want to analyze on your host system, e.g., `~/Documents/data` on Mac or Linux, or `C:\Users\Tamara\Documents\data` on Windows. The first time you run this command, the `tamslo/uyg` image is downloaded, this can take some time.
  
   To stop the interactive shell just type `exit`. Before stopping, make sure that **all files and analysis results you want to preserve** should be saved in `/home/uyg-user/data`, which writes the data to your `PATH_TO_YOUR_DATA` outside the container on the host system.

For testing your setup, see [Test Your Setup](#test-your-setup). For some installed tools and how to use them see [Run Analyses](#run-analyses). For more information regarding the Docker command, please refer to the section [Docker Explanation](#docker-explanation). For advanced usage see the sections [Customizing](#customizing) and [Updating](#updating). Lastly, we are collecting common pitfalls and solutions in [Troubleshooting](#troubleshooting).

## Test Your Setup

The following tasks lead you through all basic functionalities of this Docker image.

1. Setup Docker and start the container as described above.
   
   **Expected**: The current line should read `root@$CONTAINER_ID:/home/uyg-user#` (while `$CONTAINER_ID` is something like `9694027dbae1`); this means you are working in the container now.

2. Check tool versions (and by that that tools are installed).

   **Expected** output is written as comments next to the commands.

   ```
   plink --version    # PLINK v1.90p 64-bit (16 Jun 2020)
   plink2 --version   # PLINK v2.00a2.3LM 64-bit Intel (24 Jan 2020)
   python3 --version  # Python 3.8.5 (Note: only python3 installed, using python as a command will not work)
   ```

3. Create a file in or copy a file to `$PATH_TO_YOUR_DATA` on your host system (e.g., with Finder on Mac or Windows Explorer). List the contents of the shared directory in the container with `ls /home/uyg-user/data`.
   
   **Expected**: The file you created is visible in the container. If no file is appearing, check whether the correct path was given in the `docker run` command.
   
4. Start RStudio, open it in the browser, and login (as explained [below](#run-analyses)). Open the file you created in step 3, add some text to it, and save. Open the file from your host system.

   **Expected**: You can see the changes you made.

5. Start Jupyter, open it in the browser, and login (as explained [below](#run-analyses)). Open the file you created in step 3, add some text to it, and save. Open the file from your host system.

   **Expected**: You can see the changes you made.

6. Stop Jupyter and exit the container.

   **Expected**: You are back in your normal host terminal.
 
## Run Analyses

The `docker run` command above will start an interactive shell in which you can run tools like `plink` and `plink2`.

Your home directory, in which the interactive shell starts, is `/home/uyg-user`. From there, the data you included with `-v` can be found in the `data` subdirectory. All changes you make in this directory will be mirrored in `PATH_TO_YOUR_DATA`.

### RStudio

You can start RStudio with `rstudio-server start` and access it from your browser at http://localhost:8787; sign in with username `uyg-user` and password `1234`.

### Jupyter

You can start Jupyter with `jupyter notebook --ip 0.0.0.0 --no-browser --allow-root`. You can access it at http://localhost:8888; use the token in the URL you see in the shell when starting Jupyter for login.

To stop the Jupyter server, type `CTRL+C` and confirm with `y`.

## Docker Explanation

Explanation of the `docker run` command:
* `-v <PATH_TO_YOUR_DATA>:/home/uyg-user/data` mounts the directory `<PATH_TO_YOUR_DATA>` as a volume, which means that you can read and write in it from the container; in the container it will appear as `/home/uyg-user/data`
* `-p 8787:8787` exposes the port `8787` of the container, on which RStudio runs, to `8787` of the host
* * `-p 8888:8888` exposes the port `8888` of the container, on which Jupyter runs, to `8888` of the host
* `-it` starts an interactive shell
* `--rm` deletes the container after you close it
* `tamslo/uyg:latest` references the image on [DockerHub](https://hub.docker.com/r/tamslo/uyg)

## Customizing

We provide you with some basic tools, but if you feel like you need more you can of course install them inside your container.

To create an adapted version of the provided Docker container, omit the `--rm` flag when starting your container and adapt the container in the interactive shell (for exmaple, install other tools using `apt-get`).

After exiting the container, get its `CONTAINER_ID` with `docker ps -a` and save the container state to a new image with `docker commit $CONTAINER_ID $IMAGE_NAME`.
To start a container replace the image name `tamslo/uyg` in the command above with `$IMAGE_NAME`.

If you think the tools you installed should be available for everybody, please either contact Tamara or create a pull request (see introduction of this README for details).

## Updating

When pulling the `tamslo/uyg` image the first time, a local copy is created that is not automatically updated. To update your image in case of changes, run `docker pull tamslo/uyg`.

To check whether there is a newer version, compare the digest of your local image, which you can get with `docker images --digests`, with the digest you see on [DockerHub](https://hub.docker.com/r/tamslo/uyg/tags).

## Troubleshooting

**docker: Error response from daemon: driver failed programming external connectivity on endpoint** [...]**: Bind for 0.0.0.0:$PORT** **failed: port is already allocated.**

Docker cannot bind the port `$PORT` because it already is used. This message either means (1) that you already have a container running or (2) that another service is using `$PORT`.

(1) Run `docker ps` to see running containers. If a container is already running on port `$PORT` you can stop it with `docker stop $CONTAINER_ID`.

(2) If you do not want to stop the container or program using port `$PORT`, you can change the ports the container binds to. for example instead of binding RStudio to `8787`, try `9797` by using `-p 9797:8787` in the start command. RStudio will then be available on `http://localhost:9797`.
