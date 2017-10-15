#!/bin/bash
# OPEN - PROTOTYPE ONLY
curl -v -H "Content-Type: multipart/form-data" -X PUT \
-F metadataFile=@${PATH_TO_METADATA_FILE} -F overwrite=true \
http://${PENTAHO_SERVER_USER}:${PENTAHO_SERVER_PASSWORD}@${PENTAHO_SERVER_HOST}:${PENTAHO_SERVER_PORT}/yourdomain/plugin/data-access/api/datasource/metadata/domain/${METADATA_DOMAIN_NAME}