# Adapted from https://github.com/SonarSource/docker-sonarqube/blob/master/7.1/Dockerfile
FROM openjdk:8

ENV SONAR_VERSION=7.3

# Http port
EXPOSE 9000

RUN groupadd -r sonarqube && useradd -r -g sonarqube sonarqube

RUN set -x \
    # pub   2048R/D26468DE 2015-05-25
    #       Key fingerprint = F118 2E81 C792 9289 21DB  CAB4 CFCA 4A29 D264 68DE
    # uid                  sonarsource_deployer (Sonarsource Deployer) <infra@sonarsource.com>
    # sub   2048R/06855C1D 2015-05-25
    && gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE \
    && cd /opt \
    && curl -o sonarqube.zip -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && curl -o sonarqube.zip.asc -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && mkdir sonarqube/extensions/downloads \
    && chown -R root:root sonarqube \
    && chown -R sonarqube:sonarqube sonarqube/data sonarqube/logs sonarqube/temp \
    && rm sonarqube.zip* \
    && rm -rf sonarqube/bin/* sonarqube/extensions/plugins/*

VOLUME "/opt/sonarqube/data"

WORKDIR /opt/sonarqube
RUN cd extensions/plugins && \
    curl -sSL --remote-name-all \
        https://binaries.sonarsource.com/Distribution/sonar-css-plugin/sonar-css-plugin-1.0.2.611.jar \
        https://binaries.sonarsource.com/Distribution/sonar-html-plugin/sonar-html-plugin-3.0.1.1444.jar \
        https://binaries.sonarsource.com/Distribution/sonar-java-plugin/sonar-java-plugin-5.8.0.15699.jar \
        https://binaries.sonarsource.com/Distribution/sonar-javascript-plugin/sonar-javascript-plugin-5.0.0.6962.jar \
        https://binaries.sonarsource.com/Distribution/sonar-kotlin-plugin/sonar-kotlin-plugin-1.2.0.1994.jar \
        https://binaries.sonarsource.com/Distribution/sonar-ldap-plugin/sonar-ldap-plugin-2.2.0.608.jar \
        https://binaries.sonarsource.com/Distribution/sonar-scm-git-plugin/sonar-scm-git-plugin-1.4.1.1128.jar \
        https://binaries.sonarsource.com/Distribution/sonar-typescript-plugin/sonar-typescript-plugin-1.8.0.3332.jar \
        https://binaries.sonarsource.com/Distribution/sonar-xml-plugin/sonar-xml-plugin-1.5.1.1452.jar \
        https://github.com/Cognifide/AEM-Rules-for-SonarQube/releases/download/v0.10/aemrules-0.10.jar \
        https://github.com/gabrie-allaigre/sonar-gitlab-plugin/releases/download/4.0.0/sonar-gitlab-plugin-4.0.0.jar \
        https://github.com/sbaudoin/sonar-yaml/releases/download/v1.0.1/sonar-yaml-plugin-1.0.1.jar \
        https://github.com/spotbugs/sonar-findbugs/releases/download/3.8.0/sonar-findbugs-plugin-3.8.0.jar

USER sonarqube
ENTRYPOINT java -jar lib/sonar-application-$SONAR_VERSION.jar -Dsonar.log.console=true
