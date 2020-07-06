FROM alpine:3.10.2

COPY var/build/go/go-goccy-json/go-goccy-json /yaml/bin/

ENV PATH="/yaml/bin:$PATH"
