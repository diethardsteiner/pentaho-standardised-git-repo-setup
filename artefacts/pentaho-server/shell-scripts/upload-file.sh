#!/bin/bash

# OPEN - DUMMY ONLY

# sample values
# PATH_TO_SOURCE_FILE=/home/dsteiner/Downloads/report1.xanalyzer
# PENTAHO_SERVER_REPO_TARGET_PATH=/public/report1.xanalyzer

curl -v -X POST -H "Content-Type: multipart/form-data" \
-F fileUpload=@${PATH_TO_SOURCE_FILE} \
-F overwriteFile=true \
-F importPath=${PENTAHO_SERVER_REPO_TARGET_PATH} \
http://${PENTAHO_SERVER_USER}:${PENTAHO_SERVER_PASSWORD}@${PENTAHO_SERVER_HOST}:${PENTAHO_SERVER_PORT}/pentaho/api/repo/publish/publishfile