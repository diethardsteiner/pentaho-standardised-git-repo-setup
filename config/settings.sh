#!/bin/bash

# ========== ORGANISATION SPECFIC CONFIGURATION PROPERTIES =========== #

## ~~~~~~~~~~~~~~~~~ AMEND FOR YOUR ORANGISATION ~~~~~~~~~~~~~~~~~~~~~##
##                      ______________________                        ##
# The SSH or HTTPS URL to clone the modules repo
export PSGRS_MODULES_GIT_REPO_URL=git@github.com:diethardsteiner/pentaho-pdi-modules.git
# **Note**: If this repo is not present yet, use this script 
# to create it and push it to your Git Server (GitHub, etc).

## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
### TARGET ENVIRONMENT SETTINGS ####
export PSGRS_PDI_DIR=${HOME}/design-tools/data-integration
export PSGRS_LOG_DIR=${HOME}/logs
### SETTINGS FOR GIT HOOKS ###
export PSGRS_GIT_HOOKS_CHECKS_NEW_FILES_ONLY="Y"
# pipe delimited list of accepted database connection names
export PSGRS_PDI_ACCEPTED_DATABASE_CONNECTION_NAMES_REGEX="^module\_.*|^hive_generic$|^impala_generic$|^mysql_process_control$"
# regex to identify valid file extensions in a code repo
export PSGRS_GIT_CODE_REPO_ACCEPTED_FILE_EXTENSIONS_REGEX="cda$|cdfde$|css$|csv$|html$|jpeg$|js$|json$|kdb$|kjb$|ktr$|md$|png$|prpt$|prpti$|sh$|svg$|txt$|wcdf$|xanalyzer$|xmi$|xml$"
# regex to identify valid file extensions in a config repo
export PSGRS_GIT_CONFIG_REPO_ACCEPTED_FILE_EXTENSIONS_REGEX="md$|properties$|sh$|json$|xml$|txt$|csv$"
# regex specifying the accepted git branch names
export PSGRS_GIT_REPO_ACCEPTED_BRANCH_NAMES_REGEX="^master$|^dev$|^feature\_.+|^release\_.+|^hotfix\_.+"
# regex specfying any words that should not show up in file and folder names
export PSGRS_FILE_OR_FOLDER_NAME_FORBIDDEN_KEYWORD="(dev|test|beta|new|v[0-9]{1})"
# regex specifying the accepted pdi parameter or variable name
export PSGRS_PDI_ACCEPTED_PARAMETER_OR_VARIABLE_NAME="(^(VAR\_|PROP\_|PARAM\_)[A-Z0-9\_]+|^(Internal|awt|embedded|felix|file|https|java|karaf|log4j|org|sun|user|vfs)[a-zA-Z\.]+)"