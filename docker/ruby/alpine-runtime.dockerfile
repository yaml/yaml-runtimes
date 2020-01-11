FROM alpine:3.10.2

RUN apk update && \
  apk add \
    less \
    ruby \
    ruby-json \
    wget \
    busybox \
  && true

COPY var/build/ruby /
COPY docker/ruby/testers /yaml/bin/

ENV PATH="/yaml/bin:$PATH"
