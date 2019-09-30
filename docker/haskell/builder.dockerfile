FROM alpine:3.10.2

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

