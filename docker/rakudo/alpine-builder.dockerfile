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
    perl Configure.pl --backend=moar --gen-moar --prefix /rakudo-star && \
    make && \
    make install && \
    cd /tmp && \
    rm -rf /tmp/rakudo && \
  true

RUN mkdir /tmp/rakudo && cd /tmp/rakudo \
    && wget https://github.com/rakudo/rakudo/releases/download/2019.11/rakudo-2019.11.tar.gz \
    && tar xvf rakudo-2019.11.tar.gz \
    && cd rakudo-2019.11 \
    && perl Configure.pl --gen-moar  --backends=moar --prefix /rakudo \
    && make \
    && make install \
    && cd /tmp \
    && rm -rf /tmp/rakudo \
  && true

ENV PATH="/rakudo-star/share/perl6/site/bin:/rakudo-star/bin:$PATH"
