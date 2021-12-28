FROM alpine:3.15.0

RUN apk update && \
  apk add \
    less \
    busybox \
    openjdk9-jre-headless \
    inotify-tools \
  && true

COPY var/build/java /
COPY docker/java/testers /yaml/bin/

ENV PATH="/yaml/bin:$PATH"

ENV RUNTIME=java
