#!/bin/sh

set -e -x

[[ "$ZINC_HOME" ]]    || ZINC_HOME="/opt/zinc"
[[ "$ZINC_VERSION" ]] || ZINC_VERSION="0.3.9"

[[ "$ZINCER_NAME" ]]  || ZINCER_NAME="zincer"
[[ "$ZINCER_PATH" ]]  || ZINCER_PATH="$ZINC_HOME/$ZINCER_NAME"

ZINC_FOLDER="zinc-${ZINC_VERSION}"
ZINC_PACKAGE="${ZINC_PACKAGE}.tgz"
ZINC_ARCHIVE="http://downloads.typesafe.com/zinc/$ZINC_VERSION/$ZINC_PACKAGE"
 
[[ "$ZINCER_CODE" ]]  || ZINCER_CODE=$(cat << 'ZINCER_END'
#!/bin/sh

[[ $ZINC_HOME ]]    || ZINC_HOME="/opt/zinc"
[[ $ZINC_PORT ]]    || ZINC_PORT=3030
[[ $ZINC_TIMEOUT ]] || ZINC_TIMEOUT=0

[[ $JAVA_EXEC ]]  || JAVA_EXEC="java"
[[ $JAVA_META ]]  || JAVA_META=512m
[[ $JAVA_HEAP ]]  || JAVA_HEAP=1024m
[[ $JAVA_CODE ]]  || JAVA_CODE=256m
[[ $JAVA_STACK ]] || JAVA_STACK=1m

command="\
\
$JAVA_EXEC \
\
-server \
-XX:+UseG1GC \
-XX:+DoEscapeAnalysis \
-XX:+UseCompressedOops \
-XX:+UseCompressedClassPointers \
-XX:+HeapDumpOnOutOfMemoryError \
-XX:InitialHeapSize=$JAVA_HEAP \
-XX:MaxHeapSize=$JAVA_HEAP \
-XX:ThreadStackSize=$JAVA_STACK \
-XX:MetaspaceSize=$JAVA_META \
-XX:MaxMetaspaceSize=$JAVA_META \
-XX:InitialCodeCacheSize=$JAVA_CODE \
-XX:ReservedCodeCacheSize=$JAVA_CODE \
\
-Djava.net.preferIPv4Stack=true \
\
-Dzinc.home=$ZINC_HOME \
-classpath $ZINC_HOME/lib/*:. \
com.typesafe.zinc.Nailgun \
$ZINC_PORT $ZINC_TIMEOUT \
"

exec $command
ZINCER_END
)

###

apk add --no-cache --virtual=build-group ca-certificates wget
 
cd "/tmp"

wget --no-verbose "$ZINC_ARCHIVE"
 
tar -xzf "$ZINC_PACKAGE"

mkdir -p "$ZINC_HOME"

mv "/tmp/$ZINC_FOLDER" "$ZINC_HOME"

echo "$ZINCER_CODE" > "$ZINCER_PATH"

chmod 755 "$ZINCER_PATH"
 
ln -s "$ZINCER_PATH" "/usr/bin/$ZINCER_NAME"

rm "/tmp/"*

apk del build-group
