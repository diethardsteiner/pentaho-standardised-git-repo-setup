#!/bin/sh
JOB_PATH="your_project_name"
JOB_NAME="jb_name"

#BASE_DIR=$(dirname 0)
# to make it run with crontab as well
BASE_DIR="$( cd "$( /usr/bin/dirname "$0" )" && pwd )"
echo "The shell script is running from following directory: ${BASE_DIR}"
# the repo name has to be the env name
source ${BASE_DIR}/wrapper.sh $JOB_PATH $JOB_NAME
