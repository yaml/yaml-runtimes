FROM alpine:3.10.2

RUN apk update && \
  apk add \
    less \
    ruby \
    ruby-json \
    wget \
    busybox \
  && true

COPY testers /yaml/
