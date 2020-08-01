FROM alpine:3.10.2

RUN apk update && \
  apk add \
    less \
    git \
    python3 \
    python3-dev \
    py3-pip \
    gcc \
    musl \
    musl-dev \
    wget \
  && true

