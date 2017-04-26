#!/bin/sh

# Debugging...
set -x

pid=0

# Replace environment variables in the configuration file first. Since this
# is done at runtime by the container it won't be persisted.
envsubst < repo-connector-template.conf > cfg/repo-connector.conf

JAVA_XMS=${JAVA_XMS:-1024M}
JAVA_XMX=${JAVA_XMX:-3584M}

# This signal handling is based on this blog post:
# https://medium.com/@gchudnov/trapping-signals-in-docker-containers-7a57fdda7d86
sig_handler()
{
    if [ ${pid} -ne 0  ]; then
        /opt/repo-connector/stop-connector.sh
        wait "${pid}"
        exit 143; # 128 + 15 -- SIGTERM
    fi
}

# Setup handlers
trap "sig_handler" HUP INT QUIT TERM

java -Xms${JAVA_XMS} -Xmx${JAVA_XMX} -jar /opt/repo-connector/${CONNECTOR_JAR_PREFIX}.jar -start &

pid="${!}"

# Wait forever, but allow handling signals...
while true; do
    wait "${pid}"
done
