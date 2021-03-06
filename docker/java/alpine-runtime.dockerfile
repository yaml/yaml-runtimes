FROM alpine:3.10.2

RUN apk update && \
  apk add \
    less \
    busybox \
    openjdk9-jre-headless \
  && true

COPY var/build/java /
COPY docker/java/testers /yaml/bin/

ENV PATH="/yaml/bin:$PATH"
