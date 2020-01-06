FROM alpine:3.10.2

RUN apk update && \
  apk add \
    less \
    git \
    python3 \
    wget \
  && true

