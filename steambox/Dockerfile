FROM brewmaster:latest
MAINTAINER rsharo "rsharo@users.noreply.github.com"
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -y install pulseaudio iceweasel steam-launcher
RUN apt-get -y install steam-launcher

ARG STEAMUSER_UID
ARG STEAMUSER_GID
RUN groupadd --gid $STEAMUSER_GID steamuser
RUN useradd steamuser --uid $STEAMUSER_UID --gid $STEAMUSER_GID --shell /bin/bash --home /home/steamuser

USER steamuser
WORKDIR /home/steamuser
ENV HOME /home/steamuser
CMD ["/bin/bash"]

