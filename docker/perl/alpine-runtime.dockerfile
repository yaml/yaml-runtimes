FROM alpine:3.10.2

RUN apk update && \
  apk add \
    less \
    perl \
    wget \
    busybox \
  && true

ENV PERL5LIB=/perl5/lib/perl5

COPY var/build/perl /
COPY docker/perl/testers /yaml/bin/

ENV PATH="/yaml/bin:$PATH"
