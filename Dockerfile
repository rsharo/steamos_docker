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
RUN apt-get update && \
	apt-get -y install fakechroot fakeroot debootstrap && \
	apt-get -y install docker-engine

# Retrieve valve-archive-keyring.gpg
RUN apt-get -y install valve-archive-keyring

# Set up "builder" user
RUN useradd -ms /bin/bash -d /home/builder builder
USER builder
WORKDIR /home/builder

# customize the "jessie" debootstrap script for brewmaster compatability
RUN sed -e 's/debian-archive-keyring.gpg/valve-archive-keyring.gpg/' /usr/share/debootstrap/scripts/jessie > ./brewmaster

RUN mkdir /home/builder/steamos
VOLUME [ "/home/builder/steamos" ]

# Run mkimage.sh under fakeroot/fakechroot so we can avoid making this container privileged
SHELL [ "/bin/bash" , "-c" ]
ENTRYPOINT [ "fakechroot", "fakeroot", "/usr/share/docker-engine/contrib/mkimage.sh" ]

# resulting Dockerfile and tarball will be found in /home/builder/steamos
CMD [ "-d", "steamos", "-t", "steamos", "debootstrap", "--variant=fakechroot", "brewmaster", "http://repo.steampowered.com/steamos", "./brewmaster" ]
