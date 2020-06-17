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
RUN apt-get update \
     apt-get install -y git

# clone ccda validator repo's
RUN cd /opt/ccda \
           git clone https://github.com/onc-healthit/reference-ccda-validator.git \
           git clone https://github.com/onc-healthit/content-validator-api.git \
           git clone https://github.com/onc-healthit/2015-certification-ccda-testdata.git \
           git clone https://github.com/onc-healthit/code-validator-api.git

# Copy all configs
COPY content-validator-api /opt/ccda/vocab/scenarios/
COPY configuration/referenceccdaservice.xml /opt/ccda/referenceccdaservice.xml
COPY reference-ccda-validator-master/configuration/ccdaReferenceValidatorConfig.xml /opt/ccda

COPY configuration/referenceccdaservice.xml $CATALINA_BASE/conf/[enginename]/[hostname]/
COPY code-validator-api /opt/

# download the needed war file
GET https://github.com/onc-healthit/reference-ccda-validator/releases/download/1.0.45/referenceccdaservice.war

# copy war file to tomcat webapps dir
COPY referenceccdaservice.war /apache-tomcat-7.0.57/webapps

# copy references.xml to Catalina/localhost dir
COPY configuration/referenceccdaservice.xml /apache-tomcat-7.0.53/conf/Catalina/localhost/

COPY code-validator-api/docs/ValueSetsHandCreatedbySITE/ /opt/ccda/vocab/valueset_repository/VSAC

RUN chown -R tomcat:tomcat /opt/ccda

WORKDIR $CATALINA_HOME
EXPOSE 8080
CMD ["catalina.sh", "run"]
