FROM alpine:3.12.0

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
  wget https://nim-lang.org/download/nim-0.20.2-linux_x64.tar.xz && \
  tar xvf nim-0.20.2-linux_x64.tar.xz && \
  cd nim-0.20.2/ && \
  sh build.sh && \
  bin/nim c koch && \
  ./koch tools && \
  ln -s /nim/nim-0.20.2//bin/nim /bin/nim
