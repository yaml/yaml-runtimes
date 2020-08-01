FROM alpine:3.12.0

RUN apk update && \
  apk add \
    musl \
    g++ \
    make \
    ruby-rdoc \
    less \
    ruby \
    ruby-dev \
    ruby-json \
    wget \
    busybox \
  && true

