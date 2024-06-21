FROM alpine:3.20

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

