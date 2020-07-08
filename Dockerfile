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
RUN mkdir -p /etc/tomcat/Catalina/localhost

#Set working directory
WORKDIR /opt/ccda

RUN apt-get update
RUN apt-get install -y git

# Copy validator-api xlsx's
COPY code-validator-api/codevalidator-api/docs/ValueSetsHandCreatedbySITE/*.xlsx /opt/ccda/vocab/valueset_repository/VSAC/

# Copy all configs
COPY content-validator-api /opt/ccda/vocab/scenarios/
COPY configuration/referenceccdaservice.xml /opt/ccda/referenceccdaservice.xml
COPY reference-ccda-validator/configuration/ccdaReferenceValidatorConfig.xml /opt/ccda

ADD 2015-certification-ccda-testdata /opt/ccda/vocab/scenarios/

# copy web.xml file to tomcat dir
COPY configuration/web.xml /etc/tomcat/web.xml

# copy war file to tomcat webapps dir
COPY referenceccdaservice.war /usr/local/tomcat/webapps
COPY referenceccdaservice.war /var/lib/tomcat/webapps/referenceccdaservice.war

# reference file may need to go into a different dir
COPY configuration/referenceccdaservice.xml /etc/tomcat/Catalina/localhost/referenceccdaservice.xml
COPY configuration/referenceccdaservice.xml /usr/local/tomcat/conf/Catalina/localhost/referenceccdaservice.xml


EXPOSE 8080
WORKDIR $CATALINA_HOME
CMD ["catalina.sh", "run"]
