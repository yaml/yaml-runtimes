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
COPY dotnet/testers /yaml/bin/
COPY haskell/build /
COPY haskell/testers /yaml/bin/
COPY java/build /
COPY java/testers /yaml/bin/
COPY lua/build /
COPY lua/testers /yaml/bin/
COPY node/build /
COPY node/testers /yaml/bin/
COPY perl/build /
COPY perl/testers /yaml/bin/
COPY rakudo/build /
COPY rakudo/testers /yaml/bin/
COPY rakudo/rakudo-runtime /rakudo
COPY python/build /
COPY python/testers /yaml/bin/
COPY ruby/testers /yaml/bin/
COPY static/build /
COPY static/testers /yaml/bin/

ENV NODE_PATH=/node/node_modules
ENV PERL5LIB=/perl5/lib/perl5
ENV PERL6LIB="inst#/perl6"
ENV PYTHONPATH=/python/lib/python3.7/site-packages
ENV PATH="/rakudo/bin:$PATH"

ENV PATH="/yaml/bin:$PATH"
