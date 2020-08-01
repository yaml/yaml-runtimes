FROM alpine:3.12.0

RUN apk update && \
  apk add \
    less \
    busybox \
    libstdc++ \
  && true

COPY var/build/static /
COPY docker/static/testers /yaml/bin/

ENV PATH="/yaml/bin:$PATH"
