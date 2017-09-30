#!/bin/bash
source ./ci-settings.sh
# we need PDI_DIR
source ../../../common-config-dev/shell-scripts/set_env_variables.sh

cd ${PDI_DIR}

./pan.sh \
-user=${PARAM_FB_PDI_REPO_USER} \
-pass=${PARAM_FB_PDI_REPO_PASSWORD} \
-rep=${PARAM_FB_PDI_REPO_NAME} \
-dir=${PARAM_FB_PDI_CI_DIR} \
-trans=tr_delete_ee_repo_folder \
-param:PARAM_DI_SERVER_REPO_PATH_TO_FOLDER=${PARAM_DI_SERVER_REPO_PATH_TO_FOLDER} \
-param:PARAM_DI_SERVER_WEB_APP_NAME=${PARAM_DI_SERVER_WEB_APP_NAME} \
-param:PARAM_PDI_EE_REPO_USER=${PARAM_EE_PDI_REPO_USER} \
-param:PARAM_PDI_EE_REPO_PASSWORD=${PARAM_EE_PDI_REPO_PASSWORD} 