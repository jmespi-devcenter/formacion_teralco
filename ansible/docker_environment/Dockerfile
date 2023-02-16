
FROM ubuntu:focal

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# OS update, then clean up
RUN apt-get -yq update && \
    apt-get -yq upgrade && \
    apt-get -yq --no-install-recommends install \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        aptitude \
        wget \
        unzip && \
    apt-get clean && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/archive/* /var/lib/apt/lists/*

EXPOSE 80 443
ENTRYPOINT ["tail", "-f", "/dev/null"]