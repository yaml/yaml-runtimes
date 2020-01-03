FROM alpine:3.10.2

RUN apk update && \
  apk add \
    less \
    busybox \
    libffi \
    gmp \
    perl \
  && true

COPY build /
COPY testers /yaml/bin/

ENV PATH="/yaml/bin:$PATH"
