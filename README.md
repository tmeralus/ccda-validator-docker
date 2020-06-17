# ccda-validator-docker
Docker file for [ccda-validator](https://github.com/onc-healthit/reference-ccda-validator)


# Tomcat Docker variables
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

# Configuration Variables
path/to/validator_configuration: /opt/ccda
/vocabulary/code_repository/
b. path/to/validator_configuration/vocabulary/valueset_repository/VSAC/
c. path/to/validator_configuration/scenarios/


. Start your tomcat instance - you should see output showing the databases getting initialized and the .war file getting deployed.
    NOTE: Allow a few moments for the vocabulary valuesets and codes to be inserted into the in-memory database.
    2. Access the endpoint. For example, localhost:8080/referenceccdaservice/
    3. For convenience, API documentation and a validation UI is included:
        API documentation - /referenceccdaservice/swagger-ui.html
        UI - referenceccdaservice/ui
