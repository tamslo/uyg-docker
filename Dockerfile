FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV INSTALLATION_DIRECTORY /opt
RUN apt-get update

RUN apt-get install -y vim wget unzip locales

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# ###############################################################################
# Install plink                                                                #
# ###############################################################################

# Commit hash in https://github.com/chrchang/plink-ng
ENV PLINK_VERSION 8a8976bdd46fa43688c3f3272efc88bb7a90458d

RUN apt-get install -y curl
RUN apt-get install -y libdigest-sha-perl
RUN apt-get install -y gcc
RUN apt-get install -y g++
RUN apt-get install -y make
RUN apt-get install -y libatlas-base-dev

RUN wget -O plink_src.zip https://github.com/chrchang/plink-ng/archive/$PLINK_VERSION.zip
RUN unzip plink_src.zip -d plink_src
RUN mv plink_src/*/* plink_src
ENV PLINK_DIRECTORY plink_src/1.9
WORKDIR $PLINK_DIRECTORY
RUN ./plink_first_compile
WORKDIR /
ENV PLINK_INSTALLATION_DIRECTORY $INSTALLATION_DIRECTORY/plink
RUN mv $PLINK_DIRECTORY $PLINK_INSTALLATION_DIRECTORY
RUN rm plink_src.zip
RUN rm -r plink_src
ENV PATH="$PATH:$PLINK_INSTALLATION_DIRECTORY"

# ###############################################################################
# Install plink2                                                                #
# ###############################################################################

ENV PLINK2_VERSION v2.00a2.3
RUN wget https://github.com/chrchang/plink-ng/releases/download/$PLINK2_VERSION/plink2_linux_x86_64.zip
RUN unzip plink2_linux_x86_64.zip -d $INSTALLATION_DIRECTORY
RUN rm plink2_linux_x86_64.zip
ENV PATH="$PATH:$INSTALLATION_DIRECTORY"

# ###############################################################################
# Install R, RStudio, and packages for exercises                                #
# ###############################################################################

ENV R_VERSION 3.6.3-2
ENV RSTUDIO_SERVER_VERSION 2022.07.0-548
ENV R_PACKAGES "'data.table','dplyr','tidyverse','ggplot2','gridExtra','ggrepel','GGally','caret','R.utils','stringr'"
RUN apt-get install -y r-base=$R_VERSION
RUN apt-get install -y gdebi-core
ENV R_DEB_FILE rstudio-server-$RSTUDIO_SERVER_VERSION-amd64.deb
RUN wget https://download2.rstudio.org/server/bionic/amd64/$R_DEB_FILE
RUN gdebi --n $R_DEB_FILE
RUN rm $R_DEB_FILE
RUN Rscript -e "install.packages(c($R_PACKAGES))"

# ###############################################################################
# Create user                                                                   #
# ###############################################################################

RUN useradd -ms /bin/bash uyg-user
RUN echo "uyg-user:1234" | chpasswd
WORKDIR /home/uyg-user

# ###############################################################################
# Install python and packages                                                   #
# ###############################################################################

RUN apt-get update
RUN apt-get install -y python3.8
RUN apt-get install -y python3-pip
RUN pip3 install --upgrade pip
RUN pip3 install numpy
RUN pip3 install pandas
RUN pip3 install plotly

# ###############################################################################
# Install Jupyter (with Python and R)                                           #
# ###############################################################################

RUN pip3 install --upgrade ipython jupyter
RUN Rscript -e 'install.packages("IRkernel")'
RUN Rscript -e 'IRkernel::installspec()'