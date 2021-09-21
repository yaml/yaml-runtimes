#!/bin/sh

set -ex
cd /tmp
cp $SOURCE .

tar xvf $SOURCE
# There must be a better way than having a commit sha in the tarball...?
cd asomov-snakeyaml-1ae5d5b705e1
#export SNAKEYAML_VERSION=$(xmlstarlet sel -t -v '/_:project/_:version' pom.xml)
mvn clean install

cp -r /buildutils/java /tmp/
cd /tmp/java
mvn clean compile -Dsnakeversion=$VERSION
mvn assembly:single -Dsnakeversion=$VERSION
mkdir -p /build/java
mv target/snake2json-*-jar-with-dependencies.jar /build/java/
rm -fr target/

