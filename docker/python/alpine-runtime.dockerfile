FROM alpine:3.15.2

RUN apk update && \
  apk add \
    less \
    python3 \
    wget \
    busybox \
    inotify-tools \
  && true

ENV PYTHONPATH=/python/lib/python3.9/site-packages

COPY var/build/python /
COPY docker/python/testers /yaml/bin/

ENV PATH="/yaml/bin:$PATH"

ENV RUNTIME=python
