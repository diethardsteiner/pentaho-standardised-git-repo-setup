#!/bin/bash
# THIS FILE IS NOT SUPPORTED YET IN THIS VERSION
### SETTINGS FOR GIT HOOKS ###
# specify whether only new files should be checked
GIT_HOOKS_CHECKS_NEW_FILES_ONLY="Y"
# pipe delimited list of accepted database connection names
PDI_ACCEPTED_DATABASE_CONNECTION_NAMES_REGEX="hive_generic|impala_generic|mysql_process_control"
# regex to identify valid file extensions in a code repo
GIT_CODE_REPO_ACCEPTED_FILE_EXTENSIONS_REGEX="cda$|cdfde$|css$|csv$|html$|jpeg$|js$|json$|kdb$|kjb$|ktr$|md$|png$|prpt$|prpti$|sh$|svg$|txt$|wcdf$|xanalyzer$|xmi$|xml$"
# regex to identify valid file extensions in a config repo
GIT_CONFIG_REPO_ACCEPTED_FILE_EXTENSIONS_REGEX="md$|properties$|sh$|json$|xml$|txt$|csv$"
# regex specifying the accepted git branch names
GIT_REPO_ACCEPTED_BRANCH_NAMES_REGEX="^master$|^feature\_.+|^release\_.+|^hotfix\_.+"
# regex specfying any words that should not show up in file and folder names
FILE_OR_FOLDER_NAME_FORBIDDEN_KEYWORD="(dev|test|beta|new|v[0-9]{1})"
# regex specifying the accepted pdi parameter or variable name
PDI_ACCEPTED_PARAMETER_OR_VARIABLE_NAME="(^(VAR\_|PROP\_|PARAM\_)[A-Z0-9\_]+|^(Internal|awt|embedded|felix|file|https|java|karaf|log4j|org|sun|user|vfs)[a-zA-Z\.]+)"