#!/bin/bash

# OPEN - DUMMY ONLY

# Sample values
# REPOSITORY_PATH_TO_PDI_JOB_OR_TRANSFORMATION=/home/user1/pdi/jb_main.kjb
# PENTAHO_SERVER_SCHEDULE_START_TIME=2017-08-14T11:46:00.000-04:00
# PDI_JOB_OR_TRANSFORMATION_NAME=jb_main

curl -X POST -v \
-H "Content-Type: application/json" \
--data "schedule.json" http://${PENTAHO_SERVER_USER}:${PENTAHO_SERVER_PASSWORD}@${PENTAHO_SERVER_HOST}:${PENTAHO_SERVER_PORT}/pentaho/api/scheduler/job