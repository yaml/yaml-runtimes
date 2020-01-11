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

COPY var/build/dotnet /
COPY docker/dotnet/testers /yaml/bin/
COPY var/build/haskell /
COPY docker/haskell/testers /yaml/bin/
COPY var/build/java /
COPY docker/java/testers /yaml/bin/
COPY var/build/lua /
COPY docker/lua/testers /yaml/bin/
COPY var/build/node /
COPY docker/node/testers /yaml/bin/
COPY var/build/perl /
COPY docker/perl/testers /yaml/bin/
COPY var/build/rakudo /
COPY docker/rakudo/testers /yaml/bin/
COPY var/build/python /
COPY docker/python/testers /yaml/bin/
COPY docker/ruby/testers /yaml/bin/
COPY var/build/static /
COPY docker/static/testers /yaml/bin/

ENV NODE_PATH=/node/node_modules
ENV PERL5LIB=/perl5/lib/perl5
ENV PERL6LIB="inst#/raku"
ENV PYTHONPATH=/python/lib/python3.7/site-packages
ENV PATH="/rakudo/bin:$PATH"

ENV PATH="/yaml/bin:$PATH"

# WORKAROUND: precompile
# precompile at installation time seems to use a different path
# for debugging: export RAKUDO_MODULE_DEBUG=1

RUN echo foo | /yaml/bin/raku-yamlish-json
RUN echo foo | /yaml/bin/raku-yamlish-raku
