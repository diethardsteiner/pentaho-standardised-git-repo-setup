#!/bin/bash
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