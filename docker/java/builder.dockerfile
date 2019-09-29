FROM alpine:3.10.2

RUN apk update && \
  apk add \
    less \
    vim \
    wget \
    musl \
    maven \
    xmlstarlet \
    openjdk8 \
  && true

