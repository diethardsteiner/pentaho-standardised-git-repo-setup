#!/bin/bash

# OPEN - DUMMY ONLY

curl -X POST -v -H "Content-Type: multipart/form-data" \
-F overwriteFile=true \
-F fileUpload=@${PATH_TO_SOURCE_ZIP_FILE} \
http://${PENTAHO_SERVER_USER}:${PENTAHO_SERVER_PASSWORD}@${PENTAHO_SERVER_HOST}:${PENTAHO_SERVER_PORT}/pentaho/api/repo/files/systemRestore