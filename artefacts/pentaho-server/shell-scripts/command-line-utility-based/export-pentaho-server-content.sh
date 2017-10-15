#!/bin/bash

# [OPEN] Use REST calls instead?

PENTAHO_SERVER_HOME=/home/dsteiner/apps/pentaho-server-ce-7.1
PENTAHO_SERVER_URL=http://localhost:8080/pentaho
PENTAHO_SERVER_USER=admin
PENTAHO_SERVER_PASSWORD=password
TARGET_FILE=/tmp/test.zip
PENTAHO_SERVER_REPO_PATH=/
LOG_FILE_PATH=/tmp/pentaho-server-export.log

cd ${PENTAHO_SERVER_HOME}
./import-export.sh \
--export \
--url=${PENTAHO_SERVER_URL} \
--username=${PENTAHO_SERVER_USER} \
--password=${PENTAHO_SERVER_PASSWORD} \
--file-path=${TARGET_FILE} \
--charset=UTF-8 \
--path=${PENTAHO_SERVER_REPO_PATH} \
--withManifest=true \
--logfile=${LOG_FILE_PATH}

# unzip 

# exlude following directories
# public/plugin-samples,public/cde/,public/Steel+Wheels/,/public/bi-developers/

# add to <git-root>/pentaho-solutions folder
 

# This script should be part of a project code repo


# exporting data sources
# cd ${PENTAHO_SERVER_HOME}
# ./import-export.sh \
# --export \
# --url=${PENTAHO_SERVER_URL} \
# --username=${PENTAHO_SERVER_USER} \
# --password=${PENTAHO_SERVER_PASSWORD} \
# --resource-type=datasource \
# --datasource-type=analysis \
# --analysis-datasource=SampleData \
# --charset=UTF-8 \
# --file-path=${TARGET_FILE} \
# --withManifest=true \
# --logfile=${LOG_FILE_PATH}