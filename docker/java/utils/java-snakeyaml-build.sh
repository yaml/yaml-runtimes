#!/bin/sh

set -ex
cd /tmp
cp $SOURCE .

tar xvf $SOURCE
cd snakeyaml-snakeyaml-*
./mvnw clean install

cp -r /buildutils/java /tmp/
cd /tmp/java
./mvnw clean compile -Dsnakeversion=$VERSION
./mvnw assembly:single -Dsnakeversion=$VERSION
mkdir -p /build/java
mv target/snake2json-*-jar-with-dependencies.jar /build/java/
rm -fr target/

