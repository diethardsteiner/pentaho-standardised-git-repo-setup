#!/bin/sh

# ======================= INPUT ARGUMENTS ============================ #

## ~~~~~~~~~~~~~~~~~~~~~~~~ DO NOT CHANGE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                      ______________________                        ##


## ------ THIS MEANT TO WORK WITH A FILE BASED PDI APPRACH ONLY ----- ##

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
    echo "JOB_HOME:         The PDI repo path. Specify '/' if job located in root dir."
    echo "JOB_NAME:         The name of the target job to run from within the wrapper"
    echo
    echo "exiting ..."
    exit 1
  else
    # PDI repo relative path for home directory of project kjb files
    JOB_HOME="$1"
    echo "JOB_HOME: ${JOB_HOME}"
    # target job name (kjb file name)
    JOB_NAME="$2"
    echo "JOB_NAME: ${JOB_NAME}"
fi


# ============= PROJECT-SPECIFIC CONFIGURATION PROPERTIES ============ #

## ~~~~~~~~~~~~~~~~~~~~~~~~ DO NOT CHANGE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                      ______________________                        ##

# some logic to automatically figure out project name and environment

WRAPPER_DIR="$( cd "$( /usr/bin/dirname "$0" )" && pwd )"
echo "The wrapper shell script is running from following directory:"
echo "${WRAPPER_DIR}"

# Path to the root directory where the common and project specific git repos are stored in
#
# we know that this shell script runs from within the 
# `proj-config-env/pdi/shell-scripts` folder
# we want to get the path to proj-config-env folder
# so we can easily extract project and environment names
PROJECT_CONFIG_DIR=${WRAPPER_DIR%/*/*}
# deployment dir is 4 levels up if common config is external
DEPLOYMENT_DIR=${WRAPPER_DIR%/*/*/*/*}
# Get project group name
PROJECT_GROUP_DIR=${WRAPPER_DIR%/*/*/*}
# Get name of project group folder 
PROJECT_GROUP_FOLDER_NAME=${PROJECT_GROUP_DIR##*/}

# The following sections expects:
# Either a common config in a common group folder
# Or a standalone project (no common config)

# Extract project name and environment from the standardised project folder name
# The folder name gets initially standardised by the `initialise-repo.sh`
# Get last `/` and apply substring from there to the end
PROJECT_CONFIG_FOLDER_NAME=${PROJECT_CONFIG_DIR##*/}
# Get substring from first character to first `-`
PROJECT_NAME=${PROJECT_CONFIG_FOLDER_NAME%%-*}
# Get substring from last `-` to the end
PDI_ENV=${PROJECT_CONFIG_FOLDER_NAME##*-}
# build path for project code dir
PROJECT_CODE_DIR=${PROJECT_GROUP_DIR}/${PROJECT_NAME}-code
# path to di files root dir - used for file-based pdi approach 
PROJECT_CODE_PDI_REPO_DIR=${PROJECT_CODE_DIR}/pdi/repo
# Path to the environment specific common configuration
# [OPEN]: make `pentaho-common` configurable - var already exists
COMMON_CONFIG_DIR="${DEPLOYMENT_DIR}/pentaho-common/common-config-${PDI_ENV}"
# workaround so that we can handle standalone projects as well
if [ ! -d ${COMMON_CONFIG_DIR} ]; then 
  echo "No common config exists, so assuming it is a standalone project ..."
  COMMON_CONFIG_DIR="${DEPLOYMENT_DIR}/${PROJECT_GROUP_FOLDER_NAME}/${PROJECT_NAME}-config-${PDI_ENV}"
fi
# source common environment variables here so that they can be used straight away for project specifc variables
source ${COMMON_CONFIG_DIR}/pdi/shell-scripts/set-env-variables.sh
# is this project using a pdi repo setup or a file based one?
if [ -f ${COMMON_CONFIG_DIR}/pdi/.kettle/repositories.xml ]
then
    echo "Note: repositories.xml does exist ... "
    IS_PDI_REPO_BASED="Y"
else
    echo "Note: repositories.xml does not exist ... "
    echo "... so assuming there is a file-based PDI setup in place."
    IS_PDI_REPO_BASED="N"
fi

# Absolute path for project log files
PROJECT_LOG_HOME="${PROJECT_GROUP_DIR}/logs/${PDI_ENV}"



# ============= PROJECT-SPECIFIC CONFIGURATION PROPERTIES ============ #

## ~~~~~~~~~~~~~~~~~~~~ AMEND FOR YOUR PROJECT ~~~~~~~~~~~~~~~~~~~~~~~##
##                      ______________________                        ##

# PDI repo name
PDI_REPO_NAME="{{ PSGRS_PROJECT_NAME }}"
# PDI user name
PDI_REPO_USER="yourUserName"
# PDI password
PDI_REPO_PASS="yourPassword"
# PDI repo root dir: if your repo has a deep hierarchy and the first few levels do not hold any
# files - this saves you from specifying always the full path for the job directory as well as
# helps if the root directory is located in different levels on differnet environments
# e.g. if in dev your project folder is in the root but in prod within /home/pentaho
# so for prod set PDI_REPO_MAIN_DIR_PATH to /home/pentaho
PDI_REPO_MAIN_DIR_PATH=""



# ============== JOB-SPECIFIC CONFIGURATION PROPERTIES =============== #

## ~~~~~~~~~~~~~~~~~~~~~~~~ DO NOT CHANGE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                      ______________________                        ##


# PDI repo directory path
PDI_ARTEFACT_DIRECTORY_PATH=${PDI_REPO_MAIN_DIR_PATH}/${JOB_HOME}
# Project logs file name
JOB_LOG_FILE="${JOB_NAME}.err.log"
# Project historic logs filename
JOB_LOG_HIST_FILE="${JOB_NAME}.hist.log"
# Project properties file
PROJECT_PROPERTIES_FILE="${PROJECT_CONFIG_DIR}/pdi/properties/${PROJECT_NAME}.properties"
# Job properties file
JOB_PROPERTIES_FILE="${PROJECT_CONFIG_DIR}/pdi/properties/${JOB_NAME}.properties"
# PDI repo full path for home directory of wrapper job
# --- [OPEN] --- Wrapper has to be part of the modules repo
WRAPPER_JOB_HOME="${PDI_REPO_MAIN_DIR_PATH}/modules/master_wrapper"
# PDI wrapper job name
WRAPPER_JOB_NAME="jb_master_wrapper"
# get currently selected branche names
cd ${COMMON_CONFIG_DIR}
COMMON_CONFIG_DIR_BRANCH=`git branch`
cd ${PROJECT_CONFIG_DIR}
PROJECT_CONFIG_DIR_BRANCH=`git branch`
cd ${PROJECT_CODE_DIR}
PROJECT_CODE_DIR_BRANCH=`git branch`


START_DATETIME=`date '+%Y-%m-%d_%H-%M-%S'`
START_UNIX_TIMESTAMP=`date "+%s"`


mkdir -p ${PROJECT_LOG_HOME}


echo "Location of log file: ${PROJECT_LOG_HOME}/${JOB_LOG_FILE}"

cat > ${PROJECT_LOG_HOME}/${JOB_LOG_FILE} <<EOL

Starting at: ${START_DATETIME}

-----------------------------------------------------------------------
Running script with the following environment variables:

PDI Environment (PDI_ENV):                   ${PDI_ENV}
Location of Kettle properties (KETTLE_HOME): ${KETTLE_HOME}
Location of Common Configuration:            ${COMMON_CONFIG_DIR}   Branch: ${COMMON_CONFIG_DIR_BRANCH}
Location of Project Configuration:           ${PROJECT_CONFIG_DIR}  Branch: ${PROJECT_CONFIG_DIR_BRANCH}
Location of Project Code:                    ${PROJECT_CODE_DIR}     Branch: ${PROJECT_CODE_DIR_BRANCH}
Project Properties File Location:            ${PROJECT_PROPERTIES_FILE}
Job Properties File Location:                ${JOB_PROPERTIES_FILE}
Directory containing PDI installation:       ${PDI_DIR}
PDI Job Directory:                           ${PDI_ARTEFACT_DIRECTORY_PATH}
PDI Job Filename:                            ${JOB_NAME}
Location of log file:                        ${PROJECT_LOG_HOME}/${JOB_LOG_FILE}
-----------------------------------------------------------------------

EOL



# ====================== PDI KITCHEN WRAPPER ========================= #

## ~~~~~~~~~~~~~~~~~~~~~~~~ DO NOT CHANGE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                      ______________________                        ##


cd ${PDI_DIR}


if [ ${IS_PDI_REPO_BASED} = "Y" ]
then
  ./kitchen.sh -rep="${PDI_REPO_NAME}" -user="${PDI_REPO_USER}" -pass="${PDI_REPO_PASS}" -dir="${WRAPPER_JOB_HOME}" -job="${WRAPPER_JOB_NAME}" \
  -param:PARAM_PROJECT_PROPERTIES_FILE="${PROJECT_PROPERTIES_FILE}" \
  -param:PARAM_JOB_PROPERTIES_FILE="${JOB_PROPERTIES_FILE}" \
  -param:PARAM_JOB_NAME="${JOB_NAME}" \
  -param:PARAM_TRANSFORMATION_NAME="" \
  -param:PARAM_PDI_ARTEFACT_DIRECTORY_PATH="${PDI_ARTEFACT_DIRECTORY_PATH}" \
  -param:PARAM_CONTROL_FILE_DIRECTORY="/tmp/{{ PSGRS_PROJECT_NAME }}/" \
  -param:PARAM_CONTROL_FILE_NAME="${JOB_NAME}" \
  >> ${PROJECT_LOG_HOME}/${JOB_LOG_FILE} 2>&1
else
  ./kitchen.sh \
  -file="${PROJECT_CODE_PDI_REPO_DIR}/${WRAPPER_JOB_HOME}/${WRAPPER_JOB_NAME}.kjb" \
  -param:PARAM_PROJECT_PROPERTIES_FILE="${PROJECT_PROPERTIES_FILE}" \
  -param:PARAM_JOB_PROPERTIES_FILE="${JOB_PROPERTIES_FILE}" \
  -param:PARAM_JOB_NAME="${JOB_NAME}" \
  -param:PARAM_TRANSFORMATION_NAME="" \
  -param:PARAM_PDI_ARTEFACT_DIRECTORY_PATH="${PROJECT_CODE_PDI_REPO_DIR}/${PDI_ARTEFACT_DIRECTORY_PATH}" \
  -param:PARAM_CONTROL_FILE_DIRECTORY="/tmp/{{ PSGRS_PROJECT_NAME }}/" \
  -param:PARAM_CONTROL_FILE_NAME="${JOB_NAME}" \
  >> ${PROJECT_LOG_HOME}/${JOB_LOG_FILE} 2>&1
fi

RES=$?

END_DATETIME=`date '+%Y-%m-%d_%H-%M-%S'`
END_UNIX_TIMESTAMP=`date "+%s"`
echo
echo "End DateTime: ${END_DATETIME}" >> ${PROJECT_LOG_HOME}/${JOB_LOG_FILE}


DURATION_IN_SECONDS=`expr ${END_UNIX_TIMESTAMP} - ${START_UNIX_TIMESTAMP}`
#DURATION_IN_MINUTES=`echo "scale=0;${DURATION_IN_SECONDS}/60" | bc`
DURATION_IN_SECONDS_MSG=`printf '%dh:%dm:%ds\n' $((${DURATION_IN_SECONDS}/(60*60))) $((${DURATION_IN_SECONDS}%(60*60)/60)) $((${DURATION_IN_SECONDS}%60))`

# Project historic logs filename
JOB_LOG_HIST_FILE="${JOB_NAME}.hist.log"
# Project archive logs filename
PROJECT_LOG_ARCHIVE_FILE="${JOB_NAME}_${END_DATETIME}.err.log"

# Get the duration in human-readable format
# DURATION=`grep "Processing ended after " ${PROJECT_LOG_HOME}/${JOB_LOG_FILE} | sed -n -e 's/^.*Processing ended after after //p'`

echo "Result: ${RES}"
# DURATION_IN_SECONDS calc missing
echo "Start: ${START_DATETIME} END: ${END_DATETIME} Result: ${RES} Duration: ${DURATION_IN_SECONDS_MSG} - Duration in Seconds: ${DURATION_IN_SECONDS}s" >> ${PROJECT_LOG_HOME}/${JOB_LOG_HIST_FILE}
cat ${PROJECT_LOG_HOME}/${JOB_LOG_FILE} > ${PROJECT_LOG_HOME}/${PROJECT_LOG_ARCHIVE_FILE}

exit ${RES}
