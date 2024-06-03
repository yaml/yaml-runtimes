FROM alpine:3.20

RUN apk update && \
  apk add \
    less \
    python3 \
    wget \
    busybox \
    inotify-tools \
  && true

ENV PYTHONPATH=/python/lib/python3.12/site-packages

COPY var/build/python /
COPY docker/python/testers /yaml/bin/

ENV PATH="/yaml/bin:$PATH"

ENV RUNTIME=python
