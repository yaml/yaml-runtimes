FROM alpine:3.12.0

RUN apk update && \
  apk add \
    less \
    ruby \
    ruby-json \
    wget \
    busybox \
  && true

COPY var/build/ruby /
COPY docker/ruby/testers /yaml/bin/

ENV PATH="/yaml/bin:$PATH"

ENV RUBYLIB=/ruby/gems/psych/lib
