FROM steambox
MAINTAINER Jereme Corrado "jereme@zoion.net"

USER root

RUN apt-get install -y debian-archive-keyring
RUN echo "deb http://ftp.debian.org/debian/ jessie-backports main contrib non-free" > /etc/apt/sources.list.d/jessie-backports.list
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y -t jessie-backports nvidia-driver

USER steamuser
