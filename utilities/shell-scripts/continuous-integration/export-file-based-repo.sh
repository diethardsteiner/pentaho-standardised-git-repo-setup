#!/bin/bash

read REPO USER PASSWORD TARGET

cd ${PDI_DIR}
./kitchen.sh \
  -repo=${REPO} \
  -user=${USER} \
  -pass=${PASSWORD} \
  -dir=${DIRECTORY} \
  -job=jb_export_repo_all_objects \
  -param:PARAM_DI_REPO_NAME=${USER} \
  -param:PARAM_DI_REPO_USER={USER} \
  -param:PARAM_DI_REPO_PASSWORD=${PASSWORD} \
  -param:PARAM_DI_REPO_EXPORT_TARGET_FILE_PATH=${TARGET}