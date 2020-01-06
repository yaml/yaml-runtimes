FROM alpine:3.10.2

RUN apk update && \
  apk add \
    less \
    wget \
    busybox \
    luajit \
    yaml-dev \
  && true

COPY build /
COPY testers /yaml/bin/

ENV PATH="/yaml/bin:$PATH"
