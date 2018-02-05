#!/bin/bash

# ========== ORGANISATION SPECFIC CONFIGURATION PROPERTIES =========== #

## ~~~~~~~~~~~~~~~~~ AMEND FOR YOUR ORANGISATION ~~~~~~~~~~~~~~~~~~~~~##
##                      ______________________                        ##
# The SSH or HTTPS URL to clone the modules repo
export PSGRS_MODULES_GIT_REPO_URL=git@github.com:diethardsteiner/pentaho-pdi-modules.git
# **Note**: If this repo is not present yet, use this script 
# to create it and push it to your Git Server (GitHub, etc).

## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
### TARGET ENVIRONMENT SETTINGS ###
export PSGRS_PDI_DIR=${HOME}/apps/data-integration
export PSGRS_LOG_DIR=${HOME}/logs
# OPEN: NEXT FOUR ONES NOT INTEGRATED YET ... they are for the wrapper.sh
export PSGRS_PDI_REPO_NAME=
export PSGRS_PDI_REPO_USER=
export PSGRS_PDI_REPO_PASS=
export PSGRS_PDI_REPO_MAIN_DIR_PATH=
### SETTINGS FOR GIT HOOKS ###
export PSGRS_GIT_HOOKS_CHECKS_NEW_FILES_ONLY="N"
# pipe delimited list of accepted database connection names
export PSGRS_PDI_ACCEPTED_DATABASE_CONNECTION_NAMES_REGEX="^module\_.*|^hive_generic$|^impala_generic$|^mysql_process_control$"
# regex to identify valid file extensions in a code repo
export PSGRS_GIT_CODE_REPO_ACCEPTED_FILE_EXTENSIONS_REGEX="cda$|cdfde$|css$|csv$|gitignore$|html$|jpeg$|js$|json$|kdb$|kjb$|ktr$|md$|png$|prpt$|prpti$|sql$|sh$|svg$|txt$|wcdf$|xanalyzer$|xmi$|xml$"
# regex to identify valid file extensions in a config repo
export PSGRS_GIT_CONFIG_REPO_ACCEPTED_FILE_EXTENSIONS_REGEX="gitignore$|md$|properties$|sh$|json$|xml$|txt$|csv$"
# regex specifying the accepted git branch names
export PSGRS_GIT_REPO_ACCEPTED_BRANCH_NAMES_REGEX="^master$|^dev$|^feature\_.+|^release\_.+|^hotfix\_.+"
# regex specfying any words that should not show up in file and folder names
export PSGRS_FILE_OR_FOLDER_NAME_FORBIDDEN_KEYWORD="(dev|test|beta|new|v[0-9]{1})"
# regex specifying the accepted pdi parameter or variable name
export PSGRS_PDI_ACCEPTED_PARAMETER_OR_VARIABLE_NAME="(^(VAR\_|PROP\_|PARAM\_)[A-Z0-9\_]+|^(Internal|awt|embedded|felix|file|https|java|karaf|log4j|org|sun|user|vfs)[a-zA-Z\.]+)"
# regex specifying the accepted pdi job and transformation name
export PSGRS_PDI_ACCEPTED_JOB_OR_TRANSFORMATION_NAME="(.*/)?tr\_[a-z0-9\_]+\.ktr$|(.*/)?jb\_[a-z0-9\_]+\.kjb$"
# regex specifying the IP address match
export PSGRS_PDI_IP_ADDRESS_REGEX="[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"
# regex specifying the domain name match
export PSGRS_PDI_DOMAIN_NAME_REGEX="(https&#x3a;&#x2f;&#x2f;[a-zA-Z]+)|(http&#x3a;&#x2f;&#x2f;[a-zA-Z]+)|(https\:\/\/[a-zA-Z]+)|(http\:\/\/[a-zA-Z]+)|(www\.[a-zA-Z]+)"
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
### RPM BUILD ###
# directory which will hold the rpm build artefacts - should be within home dir
export PSGRS_RPM_BUILD_HOME=${HOME}/psgrs
# top level description that forms part of the rpm build - use quotation marks
export PSGRS_RPM_SUMMARY="A sample high level summary"
# slightly longer description that forms part of the rpm build - use quotation marks
export PSGRS_RPM_DESCRIPTION="A sample detailed description"