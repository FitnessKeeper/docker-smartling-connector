FROM openjdk:8-jre-alpine
MAINTAINER John Stucklen <john.stucklen@runkeeper.com>
LABEL version="1.5.4" \
      description="\
A docker image based on openjdk alpine linux that provides the smartling \
connector from Smartling: \
http://docs.smartling.com/pages/Repository-Connector/Install-and-Setup/ \
\
This image is setup with a template configuration file. To use the \
image, you must derive a new container from it and modify the template \
configuration file to match your repo settings. The template uses \
environment variables for credentials which are replaced with the actual \
values from the environment at runtime (you can pass these in when \
running the container with the -e option to run). You can also embed the \
credentials directly in the template if you'd prefer. \
\
Refer to smartling's configuration docs above for details regarding the \
configuration file. \
\
To properly shutdown the connector you should run the stop-connector.sh \
script located in the image. You can do this with the following command \
on a running connector container: \
\
  `docker exec <CONTAINER_ID> stop-connector.sh`"

# gettext is used for the envsubst command to make environment variable
# substitution into the repo-connector config file easy. The remainder
# of the packages are needed for https access for wget.
RUN apk --no-cache add gettext openssl unzip ca-certificates \
    && update-ca-certificates
WORKDIR /opt
RUN wget https://smartling-connector-public.s3.amazonaws.com/repo_connector/repo-connector-1.5.4-bin.zip \
    && unzip repo-connector-1.5.4-bin.zip \
    && ln -s repo-connector-1.5.4 repo-connector \
    && rm repo-connector-1.5.4-bin.zip \
    && rm repo-connector/cfg/repo-connector.conf
WORKDIR /opt/repo-connector
RUN adduser -D smartling
USER smartling
COPY start-connector.sh start-connector.sh
COPY stop-connector.sh stop-connector.sh
COPY repo-connector-template.conf repo-connector-template.conf
ENTRYPOINT ["./start-connector.sh"]
