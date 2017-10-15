#!/bin/bash
# OPEN - PROTOTYPE ONLY
curl -v -H "Content-Type: multipart/form-data" -X PUT \
-F uploadInput=@${PATH_TO_MONDRIAN_SCHEMA_FILE} -F overwrite=true -F xmlaEnabledFlag=false -F parameters="Datasource=${PENTAHO_SERVER_DB_CONNECTION_NAME}" \
http://${PENTAHO_SERVER_USER}:${PENTAHO_SERVER_PASSWORD}@${PENTAHO_SERVER_HOST}:${PENTAHO_SERVER_PORT}/yourdomain/plugin/data-access/api/datasource/analysis/catalog/${MONDRIAN_SCHEMA_NAME}