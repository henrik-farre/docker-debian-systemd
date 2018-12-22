# syntax=docker/dockerfile:experimental
FROM debian:stretch
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

CMD ["/lib/systemd/systemd"]

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
  apt-get update && apt-get install -y --no-install-recommends systemd python sudo bash ca-certificates aptitude

# Based on:
# - https://github.com/geerlingguy/docker-debian9-ansible/blob/master/Dockerfile
# - https://developers.redhat.com/blog/2014/05/05/running-systemd-within-docker-container/
# - https://molecule.readthedocs.io/en/latest/examples.html#systemd-container
COPY systemd-cleanup.sh /
RUN chmod +x /systemd-cleanup.sh \
    && /systemd-cleanup.sh

ARG VCS_REF="local"
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/henrik-farre/docker-debian-systemd" \
      org.label-schema.version="1.0-1" \
      maintainer="Henrik Farre <henrik@rockhopper.dk>"
