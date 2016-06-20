#!/bin/sh

set -e -x

[[ "$JAVA_VERSION" ]] || JAVA_VERSION=8
[[ "$JAVA_UPDATE" ]]  || JAVA_UPDATE=92 
[[ "$JAVA_BUILD" ]]   || JAVA_BUILD=14 
[[ "$JAVA_ARCH" ]]    || JAVA_ARCH="linux-x64"

[[ "$JAVA_BASE" ]]    || JAVA_BASE="/usr/lib/jvm"
[[ "$JAVA_HOME" ]]    || JAVA_HOME="$JAVA_BASE/default-jvm"
[[ "$JAVA_NAME" ]]    || JAVA_NAME="java-${JAVA_VERSION}-oracle"
[[ "$JAVA_HEADER" ]]  || JAVA_HEADER="Cookie: oraclelicense=accept-securebackup-cookie;"
[[ "$JAVA_REMOVE" ]]  || JAVA_REMOVE="db lib/missioncontrol lib/visualvm src.zip javafx-src.zip"

JAVA_PACKAGE="jdk-${JAVA_VERSION}u${JAVA_UPDATE}-${JAVA_ARCH}.tar.gz"
JAVA_OTN_URL="http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}u${JAVA_UPDATE}-b${JAVA_BUILD}/${JAVA_PACKAGE}"
 
apk add --no-cache --virtual=build-group ca-certificates wget
 
cd "/tmp"

wget --no-verbose --header "$JAVA_HEADER" "$JAVA_OTN_URL"
 
tar -xzf "$JAVA_PACKAGE"
 
mkdir -p "$JAVA_BASE"

mv "/tmp/jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE}" "$JAVA_BASE/$JAVA_NAME"
 
ln -s "$JAVA_NAME" "$JAVA_HOME"

ln -s "$JAVA_HOME/bin/"* "/usr/bin/"

if [[ "$JAVA_REMOVE" ]] ; then
    for entry in $JAVA_REMOVE ; do
        rm -r -f "$JAVA_HOME/$entry"  
    done  
fi 

rm "/tmp/"*

apk del build-group
