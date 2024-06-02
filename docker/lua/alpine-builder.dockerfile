FROM alpine:3.15.2

RUN apk update && \
  apk add \
    less \
    wget \
    musl \
    make \
    g++ \
    coreutils \
    unzip \
    luajit \
    luajit-dev \
    unzip \
    yaml-dev \
    yaml \
    rsync \
  && true

RUN apk add \
 && ( \
    cd / \
    && wget http://luarocks.org/releases/luarocks-3.2.1.tar.gz \
    && tar xvf luarocks-3.2.1.tar.gz \
    && cd luarocks-3.2.1 \
    && ./configure \
            --lua-suffix=jit \
            --with-lua=/usr \
            --with-lua-include=/usr/include/luajit-2.1 \
    && make build \
    && make install \
 ) \
   && rm luarocks-3.2.1.tar.gz \
   && rm -rf luarocks-3.2.1 \
 && true

