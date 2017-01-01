FROM scratch
ADD rootfs.tar.xz /
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -y install steam-launcher
CMD ["/bin/bash"]

