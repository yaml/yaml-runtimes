FROM alpine:3.10.2

RUN apk update && \
  apk add \
    less \
    vim \
    wget \
    musl \
    make \
    g++ \
    m4 \
  && true

RUN mkdir /nim && cd /nim && \
  wget https://nim-lang.org/download/nim-1.6.0.tar.xz && \
  tar xvf nim-1.6.0.tar.xz && \
  cd nim-1.6.0/ && \
  sh build.sh && \
  bin/nim c koch && \
  ./koch tools && \
  ln -s /nim/nim-1.6.0/bin/nim /bin/nim
