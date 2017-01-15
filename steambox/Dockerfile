FROM brewmaster:latest
MAINTAINER rsharo "rsharo@users.noreply.github.com"
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -y install steam-launcher
RUN apt-get -y install sudo vim less
RUN apt-get -y install iceweasel
RUN apt-get -y install pulseaudio libsdl2-2.0-0 firmware-linux-nonfree mesa-utils
RUN apt-get -y install dbus-x11
RUN apt-get -y install linux-headers-amd64 build-essential devscripts dkms
# You may need the following if linux-headers-amd64 didn't pick up the right one(s)
RUN apt-get -y install linux-headers-3.16.0-4-all

ARG BOOTSTRAP_STEAMDEPS=bootstrap_steamdeps.txt
ADD "${BOOTSTRAP_STEAMDEPS}" /root/steambox/bootstrap_steamdeps.txt
RUN yes | /usr/bin/steamdeps /root/steambox/bootstrap_steamdeps.txt

ARG STEAMUSER_UID
ARG STEAMUSER_GID
RUN groupadd --gid "${STEAMUSER_GID}" steamuser
RUN useradd steamuser --uid "${STEAMUSER_UID}" --gid "${STEAMUSER_GID}" --groups sudo,audio,video --shell /bin/bash --home /home/steamuser
RUN echo "steamuser:steamuser" | chpasswd

ADD show_motd /usr/local/bin/show_motd
RUN chmod 555 /usr/local/bin/show_motd

USER steamuser
WORKDIR /home/steamuser
ENV HOME /home/steamuser
ENTRYPOINT [ "/usr/local/bin/show_motd" ]
CMD ["/bin/bash"]
