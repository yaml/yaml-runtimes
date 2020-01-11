FROM alpine:3.10.2

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
