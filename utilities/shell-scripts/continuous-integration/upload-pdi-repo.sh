#!/bin/bash
source ./ci-settings.sh
# we need PDI_DIR
source ../../../common-config-dev/shell-scripts/set_env_variables.sh

cd ${PDI_DIR}

echo all | ./import.sh \
             -rep=${PARAM_EE_PDI_REPO_NAME} \
             -user=${PARAM_EE_PDI_REPO_USER} \
             -pass=${PARAM_EE_PDI_REPO_PASSWORD} \
             -dir=${PARAM_EE_PDI_REPO_PATH_PREFIX} \
             -file=${PARAM_FB_REPO_EXPORT_FILE_LOCATION} \
             -replace=true \
             -norules=N \
             -coe=false \
             -comment=${PARAM_COMMENT}