FROM openjdk:8-jre-alpine
MAINTAINER John Stucklen <john.stucklen@runkeeper.com>

RUN apk --no-cache add openssl unzip ca-certificates \
    && update-ca-certificates
WORKDIR /opt
RUN wget https://smartling-connector-public.s3.amazonaws.com/repo_connector/repo-connector-1.5.4-bin.zip \
    && unzip repo-connector-1.5.4-bin.zip \
    && ln -s repo-connector-1.5.4 repo-connector \
    && rm repo-connector-1.5.4-bin.zip
ENTRYPOINT ["java", "-jar", "/opt/repo-connector/repo-connector-1.5.4.jar", "-start"]
