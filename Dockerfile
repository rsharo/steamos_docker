FROM debian:jessie

MAINTAINER randy "rsharo@users.noreply.github.com"

RUN apt-get update

# Tools required for secure repo access
RUN apt-get -y install apt-transport-https ca-certificates gnupg2

# Docker key and repo
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
	echo 'deb https://apt.dockerproject.org/repo debian-jessie main' > /etc/apt/sources.list.d/docker.list

# Steam (Valve) key and repo
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 7DEEB7438ABDDD96 && \
	echo 'deb http://repo.steampowered.com/steamos brewmaster main contrib non-free' > /etc/apt/sources.list.d/valve.list

# Tools for building docker images
RUN apt-get update
RUN apt-get -y install debootstrap
RUN apt-get -y install docker-engine

# Retrieve valve-archive-keyring.gpg
RUN apt-get -y install valve-archive-keyring

# We are running in a container -- tweak mkimage.sh so it skips "docker build"
WORKDIR /usr/share/docker-engine/contrib
RUN sed -e 's/docker build/echo SKIPPING docker build/' mkimage.sh > mkimage_contained.sh
RUN chmod 555 mkimage_contained.sh

# customize the "jessie" debootstrap script for brewmaster compatability
RUN sed -e 's/debian-archive-keyring.gpg/valve-archive-keyring.gpg/' /usr/share/debootstrap/scripts/jessie > /root/brewmaster

# The following volume is mounted from the Makefile
#VOLUME [ "/root/steamos" ]

WORKDIR /root
SHELL [ "/bin/bash" , "-c" ]
ENTRYPOINT [ "/usr/share/docker-engine/contrib/mkimage_contained.sh" ]

# resulting Dockerfile and tarball will be found in /root/steamos
CMD [ "-d", "steamos", "-t", "steamos", "debootstrap", "--variant=minbase", "brewmaster", "http://repo.steampowered.com/steamos", "./brewmaster" ]

