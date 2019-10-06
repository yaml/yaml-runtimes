FROM alpine:3.10.2

RUN apk add icu-libs libintl

COPY build /
COPY testers /yaml
