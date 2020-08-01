FROM alpine:3.12.0

RUN apk add icu-libs libintl

COPY var/build/dotnet /
COPY docker/dotnet/testers /yaml/bin/

ENV PATH="/yaml/bin:$PATH"
