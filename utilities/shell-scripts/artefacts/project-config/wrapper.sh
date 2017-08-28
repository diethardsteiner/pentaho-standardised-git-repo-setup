#!/bin/sh

# ======================= INPUT ARGUMENTS ============================ #

## ~~~~~~~~~~~~~~~~~~~~~~~~ DO NOT CHANGE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                      ______________________                        ##


# environmental argument parameter
if [ $# -eq 0 ] || [ -z "$1" ] || [ -z "$2" ]
  then
    echo "ERROR: Not all mandatory arguments supplied, please supply environment and/or job arguments"
    echo
    echo "Usage: wrapper.sh [JOB NAME] [JOB HOME]"
    echo "Run a wrapper PDI job to execute input PDI jobs"
    echo 
    echo "Mandatory arguments"
    echo
    echo "JOB_HOME:         The path of the project's sub-folder in PDI repo where KJBs for this job are located"
    echo "JOB_NAME:         The name of the target job to run from within the wrapper"
    echo
    echo "exiting ..."
    exit 1
  else
    # PDI repo relative path for home directory of project kjb files
    JOB_HOME="$1"
    echo "JOB_HOME: $JOB_HOME"
    # target job name (kjb file name)
    JOB_NAME="$2"
    echo "JOB_NAME: $JOB_NAME"
fi


# ============= PROJECT-SPECIFIC CONFIGURATION PROPERTIES ============ #

## ~~~~~~~~~~~~~~~~~~~~~~~~ DO NOT CHANGE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                      ______________________                        ##

# Get path to current git repo root
PROJECT_GIT_DIR=`git rev-parse --show-toplevel`
# Extract project name and environment from the standardised project folder name
# The folder name gets initially standardised by the `initialise-repo.sh`
# Get last `/` and apply substring from there to the end
PROJECT_GIT_FOLDER=${PROJECT_GIT_DIR##*/}
# Get substring from first character to first `-`
PROJECT_NAME=${PROJECT_GIT_FOLDER%%-*}
# Get substring from last `-` to the end
PDI_ENV=${PROJECT_GIT_FOLDER##*-}
# Path to the root directory where the common and project specific git repos are stored in
BASE_DIR=${PROJECT_GIT_DIR}/..
# Path to the environment specific common configuration
COMMON_CONFIG_HOME="${BASE_DIR}/common-config-${PDI-ENV}"
# source common environment variables here so that they can be used straight away for project specifc variables
source ${COMMON_CONFIG_HOME}/shell-scripts/set_env_variables.sh
# Absolute path for home directory of project properties files
PROJECT_CONFIG_HOME="${BASE_DIR}/${PROJECT_NAME}-config-${PDI_ENV}"
# Absolute path for home directory of project log files
PROJECT_LOG_HOME="${LOG_DIR}/${PROJECT_NAME}/${PDI_ENV}"



# ============= PROJECT-SPECIFIC CONFIGURATION PROPERTIES ============ #

## ~~~~~~~~~~~~~~~~~~~~ AMEND FOR YOUR PROJECT ~~~~~~~~~~~~~~~~~~~~~~~##
##                      ______________________                        ##

# PDI repo name
PDI_REPO="yourRepoName"
# PDI user name
PDI_USER="yourUserName"
# PDI password
PDI_PASS="yourPassword"
# PDI repo root dir: if your repo has a deep hierarchy and the first few levels do not hold any
# files - this saves you from specifying always the full path for the job directory as well as
# helps if the root directory is located in different levels on differnet environments
# e.g. if in dev your project folder is in the root but in prod within /home/pentaho
# so for prod set PDI_REPO_ROOT_DIR to /home/pentaho
PDI_REPO_ROOT_DIR="/home/pentaho"



# ============== JOB-SPECIFIC CONFIGURATION PROPERTIES =============== #

## ~~~~~~~~~~~~~~~~~~~~~~~~ DO NOT CHANGE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                      ______________________                        ##


# PDI repo directory path
JOB_HOME=${PDI_REPO_ROOT_DIR}/${JOB_HOME}
# Project logs file name
JOB_LOG_FILE="${JOB_NAME}.err.log"
# Project historic logs filename
JOB_LOG_HIST_FILE="${JOB_NAME}.hist.log"
# Project properties file
PROJECT_PROPERTIES_FILE="${PROJECT_CONFIG_HOME}/properties/${PROJECT_NAME}.properties"
# Job properties file
JOB_PROPERTIES_FILE="${PROJECT_CONFIG_HOME}/properties/${JOB_NAME}.properties"
# PDI repo full path for home directory of wrapper job
# --- [OPEN] --- Wrapper has to be part of the modules repo
WRAPPER_JOB_HOME="${PDI_REPO_ROOT_DIR}/modules/di_process_execution_log"
# PDI wrapper job name
WRAPPER_JOB_NAME="jb_master_wrapper"

echo ""
echo "-----------------------------------------------------------------------"
echo "Running script with the following environment variables:"
echo
echo "PDI Environment (PDI_ENV):                   ${PDI_ENV}"
echo "Location of Kettle properties (KETTLE_HOME): ${KETTLE_HOME}"
echo "Location of Common Configuration:            ${COMMON_CONFIG_HOME}"
echo "Location of Project Configuration:           ${PROJECT_CONFIG_HOME}"
echo "Directory containing PDI installation:       ${PDI_DIR}"
echo "PDI Job Directory:                           ${JOB_PATH}"
echo "PDI Job Filename:                            ${JOB_NAME}"
echo "Location of log file:                        ${PROJECT_LOG_HOME}/${JOB_LOG_FILE}"
echo "-----------------------------------------------------------------------"
echo ""

mkdir -p $PROJECT_LOG_HOME



# ====================== PDI KITCHEN WRAPPER ========================= #

## ~~~~~~~~~~~~~~~~~~~~~~~~ DO NOT CHANGE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                      ______________________                        ##


# [OPEN] This works for PDI repositories only

START_DATETIME=`date '+%Y-%m-%d_%H-%M-%S'`
echo "Staring at: ${START_DATETIME}"

cd $PDI_DIR

./kitchen.sh \
-rep="${PDI_REP}" \
-user="${PDI_USER}" \
-pass="${PDI_PASS}" \
-dir="${WRAPPER_JOB_HOME}" \ 
-job="${WRAPPER_JOB_NAME}" \
-param:PROJECT_PROPERTIES_FILE="${PROJECT_PROPERTIES_FILE}" \
-param:JOB_PROPERTIES_FILE="${JOB_PROPERTIES_FILE}" \
-param:VAR_JOB_NAME="${VAR_JOB_NAME}" \
-param:VAR_TRANSFORMATION_NAME="" \
-param:VAR_REPOSITORY_FOLDER_PATH="${VAR_REPOSITORY_FOLDER_PATH}" \
> $PROJECT_LOG_HOME/$JOB_LOG_FILE 2>&1

RES=$?

END_DATETIME=`date '+%Y-%m-%d_%H-%M-%S'`
echo
echo "End DateTime: $END_DATETIME"
# Project historic logs filename
JOB_LOG_HIST_FILE="${JOB_NAME}.hist.log"
# Project archive logs filename
PROJECT_LOG_ARCHIVE_FILE="${JOB_NAME}_${END_DATETIME}.err.log"

# Get the duration in human-readable format
DURATION=`cat $PROJECT_LOG_HOME/$JOB_LOG_FILE | grep "Processing ended after " | sed -n -e 's/^.*Processing ended after after //p'`

echo "Result: $RES"
echo "Result: $RES" >> $PROJECT_LOG_HOME/$JOB_LOG_HIST_FILE
# SECONDS calc missing
echo "Start: $START_DATETIME END: $END_DATETIME Duration: ${SECONDS}s Result: $RES DurationHumanReadable: ${DURATION}" >> $PROJECT_LOG_HOME/$JOB_LOG_HIST_FILE
cat $PROJECT_LOG_HOME/$JOB_LOG_FILE > $PROJECT_LOG_HOME/$PROJECT_LOG_ARCHIVE_FILE

echo "Script finished: $END_DATETIME"

exit $RES
