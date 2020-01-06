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
  && wget https://github.com/rakudo/rakudo/releases/download/2019.11/rakudo-2019.11.tar.gz \
  && tar xvf rakudo-2019.11.tar.gz \
  && cd rakudo-2019.11 \
  && perl Configure.pl --gen-moar  --backends=moar --prefix /rakudo \
  && make \
  && make install \
  && cd /tmp \
  && rm rakudo-2019.11.tar.gz \
  && rm -rf rakudo-2019.11 \
  && apk del \
    make \
    g++ \
    git \
    perl \
  && true

COPY build /
COPY testers /yaml/bin/

ENV PATH="/rakudo/bin:$PATH"
ENV PERL6LIB="inst#/raku"

ENV PATH="/yaml/bin:$PATH"


# WORKAROUND: precompile
# precompile at installation time seems to use a different path
# for debugging: export RAKUDO_MODULE_DEBUG=1

RUN echo foo | /yaml/bin/raku-yamlish-json
RUN echo foo | /yaml/bin/raku-yamlish-raku
