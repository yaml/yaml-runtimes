FROM alpine:3.12.0

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

