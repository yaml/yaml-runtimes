FROM alpine:3.10.2

RUN apk update && \
  apk add \
    less \
    git \
    perl \
    perl-dev \
    perl-app-cpanminus \
    wget \
    musl \
    make \
    g++ \
  && true

