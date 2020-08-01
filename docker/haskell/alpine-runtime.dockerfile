FROM alpine:3.12.0

RUN apk update && \
  apk add \
    less \
    busybox \
    libffi \
    gmp \
    perl \
  && true

COPY var/build/haskell /
COPY docker/haskell/testers /yaml/bin/

ENV PATH="/yaml/bin:$PATH"
