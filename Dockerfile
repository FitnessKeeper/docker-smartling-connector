FROM openjdk:8-jre-alpine
MAINTAINER John Stucklen <john.stucklen@runkeeper.com>

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
VOLUME /opt/repo-connector/cfg/repository-data
ENTRYPOINT ["./start-connector.sh"]
