FROM alpine:3.10.2

RUN apk update && \
  apk add \
    less \
    python3 \
    wget \
    busybox \
  && true

ENV PYTHONPATH=/python/lib/python3.7/site-packages

COPY var/build/python /
COPY docker/python/testers /yaml/bin/

ENV PATH="/yaml/bin:$PATH"
