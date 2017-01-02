FROM steamos_buildmach:latest

MAINTAINER rsharo "rsharo@users.noreply.github.com"

RUN ln -s /usr/share/debootstrap/scripts/alchemist /root/alchemist
RUN ln -s /usr/share/debootstrap/scripts/brewmaster /root/brewmaster

USER root
WORKDIR /root
SHELL [ "/bin/bash" , "-c" ]
ENTRYPOINT [ "/bin/bash" ]
CMD [ "-i" ]
