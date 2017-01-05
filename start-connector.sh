#!/bin/sh

# Replace environment variables in the configuration file first. Since this
# is done at runtime by the container it won't be persisted.
envsubst < repo-connector-template.conf > cfg/repo-connector.conf
java -jar /opt/repo-connector/repo-connector-1.5.4.jar -start
