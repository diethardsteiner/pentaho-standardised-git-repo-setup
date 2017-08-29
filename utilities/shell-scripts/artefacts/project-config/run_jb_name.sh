#!/bin/sh
JOB_PATH="your_project_name"
JOB_NAME="jb_name"

BASE_DIR=$(dirname 0)
echo "The shell script is running from following directory: ${BASE_DIR}"
# the repo name has to be the env name
source ${BASE_DIR}/wrapper.sh $JOB_PATH $JOB_NAME
