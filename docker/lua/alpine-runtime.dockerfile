FROM alpine:3.20

RUN apk update && \
  apk add \
    less \
    wget \
    busybox \
    luajit \
    yaml-dev \
    inotify-tools \
  && true

COPY var/build/lua /
COPY docker/lua/testers /yaml/bin/

ENV PATH="/yaml/bin:$PATH"

ENV RUNTIME=lua
