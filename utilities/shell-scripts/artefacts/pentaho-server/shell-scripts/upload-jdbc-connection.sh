#!/bin/bash

# OPEN - DUMMY ONLY
function upload_jdbc_connection {

curl -vX PUT http://${PENTAHO_SERVER_USER}:${PENTAHO_SERVER_PASSWORD}@${PENTAHO_SERVER_HOST}:${PENTAHO_SERVER_PORT}/pentaho/plugin/data-access/api/datasource/jdbc/connection/${PENTAHO_SERVER_DB_CONNECTION_NAME} \
--header "Content-Type: application/json" \
--data "${PATH_TO_JSON_DB_CONNECTION_DEFINITION_FILE}" 

}