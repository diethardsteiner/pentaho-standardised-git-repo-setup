#!/bin/bash

# OPEN - DUMMY ONLY

curl http://${PENTAHO_SERVER_USER}:${PENTAHO_SERVER_PASSWORD}@${PENTAHO_SERVER_HOST}:${PENTAHO_SERVER_PORT}/pentaho/api/repo/files/backup > /tmp/backup.zip