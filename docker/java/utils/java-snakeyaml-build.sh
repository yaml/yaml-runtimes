#!/bin/sh

set -ex
cd /tmp
cp $SOURCE .

tar xvf $SOURCE
cd asomov-snakeyaml-8450addf3473
#export SNAKEYAML_VERSION=$(xmlstarlet sel -t -v '/_:project/_:version' pom.xml)
mvn clean install

cp -r /buildutils/java /tmp/
cd /tmp/java
mvn clean compile -Dsnakeversion=$VERSION
mvn assembly:single -Dsnakeversion=$VERSION
mkdir -p /build/java
mv target/snake2json-*-jar-with-dependencies.jar /build/java/
rm -fr target/

