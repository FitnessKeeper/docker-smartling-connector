#!/bin/sh

# Replace environment variables in the configuration file first. Since this
# is done at runtime by the container it won't be persisted.
envsubst < repo-connector-template.conf > cfg/repo-connector.conf

JAVA_XMS=${JAVA_XMS:-1024M}
JAVA_XMX=${JAVA_XMX:-3584M}

#java -Xms${JAVA_XMS} -Xmx${JAVA_XMX} -jar /opt/repo-connector/${CONNECTOR_JAR_PREFIX}.jar -start
/opt/repo-connector/runner.sh
