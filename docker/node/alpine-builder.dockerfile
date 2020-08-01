FROM alpine:3.12.0

RUN apk update && \
  apk add \
    less \
    git \
    nodejs \
    npm \
    wget \
    rsync \
  && true

