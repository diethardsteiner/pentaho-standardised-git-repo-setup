#!/bin/bash

# [OPEN] Use REST calls instead?

PENTAHO_SERVER_HOME=/home/dsteiner/apps/pentaho-server-ce-7.1
PENTAHO_SERVER_URL=http://localhost:8080/pentaho
PENTAHO_SERVER_USER=admin
PENTAHO_SERVER_PASSWORD=password
TARGET_FILE=/tmp/test.zip
PENTAHO_SERVER_REPO_PATH=/public
LOG_FILE_PATH=/tmp/pentaho-server-export.log


cd ${PENTAHO_SERVER_HOME}
./import-export.sh \
--import \
--url=${PENTAHO_SERVER_URL} \
--username=${PENTAHO_SERVER_USER} \
--password=${PENTAHO_SERVER_PASSWORD} \
--file-path=${TARGET_FILE} \
--charset=UTF-8 \
--path=${PENTAHO_SERVER_REPO_PATH} \
--logfile=${LOG_FILE_PATH} \
--permission=true \
--overwrite=true