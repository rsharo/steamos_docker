FROM debian:jessie

MAINTAINER randy "rsharo@users.noreply.github.com"

RUN apt-get update

VOLUME [ "/tmp/workdir" ]
WORKDIR /tmp/workdir

RUN apt-get -y install apt-transport-https ca-certificates gnupg2 && \
	apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
	apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 7DEEB7438ABDDD96 && \
	echo 'deb https://apt.dockerproject.org/repo debian-jessie main' > /etc/apt/sources.list.d/docker.list && \
	echo 'deb http://repo.steampowered.com/steamos brewmaster main contrib non-free' > /etc/apt/sources.list.d/valve.list && \
	apt-get update && \
	apt-get -y install valve-archive-keyring && \
	apt-get -y install docker-engine && \
	apt-get -y install fakechroot fakeroot debootstrap && \
	useradd -ms /bin/bash builder && \
	sed -e 's/debian-archive-keyring.gpg/valve-archive-keyring.gpg/' /usr/share/debootstrap/scripts/jessie > ./brewmaster

USER builder

ENTRYPOINT [ "fakechroot", "fakeroot", "/usr/share/docker-engine/contrib/mkimage.sh" ]

CMD [	"-d", "steamos",
	"-t", "steamos",
	"debootstrap", "--variant=fakechroot", "brewmaster", "http://repo.steampowered.com/steamos", "./brewmaster" ]
