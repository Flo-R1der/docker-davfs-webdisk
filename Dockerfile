FROM ubuntu:latest

LABEL maintainer="Florian Frei"

RUN apt-get update \
  && apt-get install -y davfs2 ca-certificates unison \
  && mkdir -p /mnt/local \
  && mkdir -p /mnt/webdrive \
  && apt-get clean \
  && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

COPY ./start-sync.sh /usr/local/bin

ENTRYPOINT [ "/usr/local/bin/start-sync.sh" ]

# docker build --file ./Dockerfile --tag davfs-webdisk .
