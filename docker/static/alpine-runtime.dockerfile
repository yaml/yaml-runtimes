FROM alpine:3.15.0

RUN apk update && \
  apk add \
    less \
    busybox \
    libstdc++ \
    inotify-tools \
  && true

COPY var/build/static /
COPY docker/static/testers /yaml/bin/

ENV PATH="/yaml/bin:$PATH"

ENV RUNTIME=static
