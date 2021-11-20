FROM alpine:3.10.2

RUN apk update && \
  apk add \
    less \
    wget \
    busybox \
    inotify-tools \
  && true

COPY var/build/rakudo /
COPY docker/rakudo/testers /yaml/bin/

ENV PATH="/rakudo/bin:$PATH"
ENV PERL6LIB="inst#/raku"

ENV PATH="/yaml/bin:$PATH"


# WORKAROUND: precompile
# precompile at installation time seems to use a different path
# for debugging: export RAKUDO_MODULE_DEBUG=1

RUN echo foo | /yaml/bin/raku-yamlish-json
RUN echo foo | /yaml/bin/raku-yamlish-raku

ENV RUNTIME=rakudo
