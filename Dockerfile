FROM ubuntu:16.04

RUN apt-get update -qq && \
    apt-get install -y rsync curl openssh-client && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

ENV PATH "$PATH:/opt/forklift/bin"

COPY files/opt /opt

CMD [ "usage" ]