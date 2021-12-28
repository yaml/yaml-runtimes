FROM alpine:3.15.0

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

