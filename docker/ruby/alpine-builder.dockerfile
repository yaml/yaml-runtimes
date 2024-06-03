FROM alpine:3.20

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

