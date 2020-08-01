FROM alpine:3.12.0

RUN apk update && \
  apk add \
    less \
    vim \
    wget \
    musl \
    g++ \
    ghc \
    cabal \
  && true

