FROM alpine:3.10.2

RUN apk update && \
  apk add \
    less \
    busybox \
    libstdc++ \
  && true

COPY build /
COPY testers /yaml
