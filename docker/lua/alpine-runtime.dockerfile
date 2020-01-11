FROM alpine:3.10.2

RUN apk update && \
  apk add \
    less \
    wget \
    busybox \
    luajit \
    yaml-dev \
  && true

COPY var/build/lua /
COPY docker/lua/testers /yaml/bin/

ENV PATH="/yaml/bin:$PATH"
