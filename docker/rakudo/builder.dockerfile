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

RUN mkdir /rakudo && cd /rakudo && \
    wget https://rakudo.org/dl/star/rakudo-star-2019.03.tar.gz && \
    tar xvf rakudo-star-2019.03.tar.gz && \
    mv rakudo-star-2019.03/* . && \
    rm -fr rakudo-star-2019.03 && \
    rm -fr rakudo-star-2019.03.tar.gz && \
    perl Configure.pl --backend=moar --gen-moar && \
    make && \
    make install && \
  true

ENV PATH="/rakudo/install/bin:/rakudo/install/share/perl6/site/bin:$PATH"
