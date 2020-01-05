FROM alpine:3.10.2

RUN apk update && \
  apk add \
    less \
    git \
    wget \
    musl \
    perl \
    make \
    g++ \
    openssl-dev \
  && true

RUN mkdir /tmp/rakudo && cd /tmp/rakudo && \
    wget https://rakudo.org/dl/star/rakudo-star-2019.03.tar.gz && \
    tar xvf rakudo-star-2019.03.tar.gz && \
    cd rakudo-star-2019.03 && \
    perl Configure.pl --backend=moar --gen-moar --prefix /rakudo && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf /tmp/rakudo && \
  true

ENV PATH="/rakudo/share/perl6/site/bin:/rakudo/bin:$PATH"
