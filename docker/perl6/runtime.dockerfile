FROM alpine:3.10.2

RUN apk update && \
  apk add \
    less \
    perl \
    wget \
    busybox \
    make \
    g++ \
    git \

  && cd /tmp \
  && wget https://github.com/rakudo/rakudo/releases/download/2019.07.1/rakudo-2019.07.1.tar.gz \
  && tar xvf rakudo-2019.07.1.tar.gz \
  && cd rakudo-2019.07.1 \
  && perl Configure.pl --gen-moar  --backends=moar --prefix /rakudo \
  && make \
  && make install \
  && cd /tmp \
  && rm rakudo-2019.07.1.tar.gz \
  && rm -rf rakudo-2019.07.1 \

  && apk del \
    make \
    g++ \
    git \
    perl \
  && true

COPY build /
COPY testers /yaml/

ENV PATH="/rakudo/bin:$PATH"
ENV PERL6LIB="inst#/perl6"
