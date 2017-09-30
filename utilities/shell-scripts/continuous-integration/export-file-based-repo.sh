#!/bin/bash
source ./ci-settings.sh
# we need KETTLE_HOME, PDI_DIR
source ../../../common-config-dev/shell-scripts/set_env_variables.sh

cd ${PDI_DIR}
./kitchen.sh \
-user=${PARAM_FB_PDI_REPO_USER} \
-pass=${PARAM_FB_PDI_REPO_PASSWORD} \
-rep=${PARAM_FB_PDI_REPO_NAME} \
-dir=${PARAM_FB_PDI_CI_DIR} \
-job=jb_export_file_repo_all_objects \
-param:PARAM_PDI_REPO_NAME=${PARAM_FB_PDI_REPO_NAME} \
-param:PARAM_PDI_REPO_USER=${PARAM_FB_PDI_REPO_USER} \
-param:PARAM_PDI_REPO_PASSWORD=${PARAM_FB_PDI_REPO_PASSWORD}  \
-param:PARAM_REPO_EXPORT_TARGET_FOLDER_AND_FILE=${PARAM_FB_REPO_EXPORT_TARGET_FOLDER_AND_FILE}

