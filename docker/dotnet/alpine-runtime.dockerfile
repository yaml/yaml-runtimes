FROM alpine:3.10.2

RUN apk add icu-libs libintl inotify-tools

COPY var/build/dotnet /
COPY docker/dotnet/testers /yaml/bin/

ENV PATH="/yaml/bin:$PATH"

ENV RUNTIME=dotnet
