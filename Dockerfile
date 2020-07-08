FROM tomcat:7.0.104-jdk8-openjdk
LABEL maintainer="Tedley Meralus <tmeralus@gmail.com>"

ARG buildno
ARG gitcommithash

RUN echo "Build number: $buildno"
RUN echo "Based on commit: $gitcommithash"

# create vocab config dirs
RUN mkdir -p /opt/ccda
RUN mkdir -p /opt/ccda/vocab
RUN mkdir -p /opt/ccda/vocab/code_repository
RUN mkdir -p /opt/ccda/vocab/scenarios
RUN mkdir -p /opt/ccda/vocab/valueset_repository
RUN mkdir -p /opt/ccda/vocab/valueset_repository/VSAC
#Set working directory
WORKDIR /opt/ccda

# download latest ccda-validator from github
# https://github.com/onc-healthit/reference-ccda-validator
RUN apt-get update
RUN apt-get install -y git

# Copy all configs
COPY content-validator-api /opt/ccda/vocab/scenarios/
COPY configuration/referenceccdaservice.xml /opt/ccda/referenceccdaservice.xml
COPY reference-ccda-validator/configuration/ccdaReferenceValidatorConfig.xml /opt/ccda

#COPY configuration/referenceccdaservice.xml $CATALINA_BASE/conf/[enginename]/[hostname]/
#COPY code-validator-api /opt/
ADD 2015-certification-ccda-testdata /opt/ccda/vocab/scenarios/

# copy war file to tomcat webapps dir
COPY referenceccdaservice.war /usr/local/tomcat/webapps

# copy references.xml to Catalina/localhost dir
COPY configuration/referenceccdaservice.xml /usr/local/tomcat/conf/Catalina/localhost/

COPY code-validator-api/codevalidator-api/docs/ValueSetsHandCreatedbySITE/ /opt/ccda/vocab/valueset_repository/VSAC/

EXPOSE 8080
WORKDIR $CATALINA_HOME
CMD ["catalina.sh", "run"]
