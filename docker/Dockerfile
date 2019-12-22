FROM alpine:3.10.2

RUN apk update && \
  apk add \
    less \
    busybox \
    libffi \
    gmp \
    perl \
    openjdk9-jre-headless \
    nodejs \
    python3 \
    ruby \
    ruby-json \
    libstdc++ \
    luajit \
    yaml-dev \
    icu-libs \
    libintl \
  && true

COPY dotnet/build /
COPY dotnet/testers /yaml
COPY haskell/build /
COPY haskell/testers /yaml
COPY java/build /
COPY java/testers /yaml
COPY lua/build /
COPY lua/testers /yaml
COPY node/build /
COPY node/testers /yaml
COPY perl5/build /
COPY perl5/testers /yaml
COPY perl6/build /
COPY perl6/testers /yaml
COPY perl6/rakudo-runtime /rakudo
COPY python/build /
COPY python/testers /yaml
COPY ruby/testers /yaml
COPY static/build /
COPY static/testers /yaml

ENV NODE_PATH=/node/node_modules
ENV PERL5LIB=/perl5/lib/perl5
ENV PERL6LIB="inst#/perl6"
ENV PYTHONPATH=/python/lib/python3.7/site-packages
ENV PATH="/rakudo/bin:$PATH"

