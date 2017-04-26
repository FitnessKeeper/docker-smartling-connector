#!/bin/sh

# Replace environment variables in the configuration file first. Since this
# is done at runtime by the container it won't be persisted.
envsubst < repo-connector-template.conf > cfg/repo-connector.conf

JAVA_XMS=${JAVA_XMS:-1024M}
JAVA_XMX=${JAVA_XMX:-3584M}

trap "/opt/repo-connector/stop-connector.sh" HUP INT QUIT TERM

java -Xms${JAVA_XMS} -Xmx${JAVA_XMX} -jar /opt/repo-connector/${CONNECTOR_JAR_PREFIX}.jar -start &

pid="${!}"

# Wait forever, but allow handling signals...
while true; do
    tail -f /dev/null & wait ${!}
done
