FROM alpine:3.12.0

RUN apk update && \
  apk add \
    less \
    nodejs \
    wget \
    busybox \
  && true

ENV NODE_PATH=/node/node_modules

COPY var/build/node /
COPY docker/node/testers /yaml/bin/

ENV PATH="/yaml/bin:$PATH"
