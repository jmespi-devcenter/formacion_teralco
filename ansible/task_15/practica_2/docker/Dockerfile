FROM ubuntu:focal

ARG USERNAME=docker
EXPOSE 22

RUN apt-get update && apt-get -yq install openssh-server sudo
RUN useradd -ms /bin/bash $USERNAME
RUN apt -y autoremove && apt -y autoclean && apt -y clean

COPY entrypoint.sh entrypoint.sh
RUN chmod +x /entrypoint.sh

USER ${USERNAME}
RUN mkdir /home/${USERNAME}/.ssh
COPY mycontainerkey.pub /home/${USERNAME}/.ssh/authorized_keys

USER root
RUN chown ${USERNAME} /home/${USERNAME}/.ssh/authorized_keys && \
    chmod 600 /home/${USERNAME}/.ssh/authorized_keys
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL " >> /etc/sudoers

ENTRYPOINT ["/entrypoint.sh"]

