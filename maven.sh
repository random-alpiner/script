#!/bin/sh

set -e -x

[[ "$MAVEN_VERSION" ]] || MAVEN_VERSION="3.3.9"

[[ "$MAVEN_HOME" ]]    || MAVEN_HOME="/usr/share/maven"

MAVEN_FOLDER="apache-maven-${MAVEN_VERSION}"
MAVEN_PACKAGE="${MAVEN_FOLDER}-bin.tar.gz"
MAVEN_ARCHIVE="http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/$MAVEN_PACKAGE"
 
apk add --no-cache --virtual=build-group ca-certificates wget
 
cd "/tmp"

wget --no-verbose "$MAVEN_ARCHIVE"
 
tar -xzf "$MAVEN_PACKAGE"

mkdir -p "$MAVEN_HOME"

mv "/tmp/$MAVEN_FOLDER" "$MAVEN_HOME"
 
ln -s "$MAVEN_HOME/bin/mvn" "/usr/bin/mvn"

rm "/tmp/"*

apk del build-group
