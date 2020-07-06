FROM alpine:3.10.2

RUN apk update && apk add go git musl-dev build-base && true
