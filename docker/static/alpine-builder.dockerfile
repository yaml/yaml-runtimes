FROM alpine:3.10.2

RUN apk update && \
  apk add \
    git \
    file \
    less \
    vim \
    wget \
    musl \
    make \
    g++ \
    m4 \
    cmake \
  && true

