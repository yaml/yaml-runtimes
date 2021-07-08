FROM alpine:3.10.2

RUN apk update && \
  apk add \
    less \
    git \
    nodejs \
    npm \
    perl \
    wget \
    rsync \
  && true

