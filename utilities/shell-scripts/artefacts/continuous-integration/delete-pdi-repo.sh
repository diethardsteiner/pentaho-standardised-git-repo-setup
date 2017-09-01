#!/bin/bash

read DEPLOYMENT_PATH USER PASSWORD DI_HOST DI_PORT  REPO

cd ${PDI_DIR}
./pan.sh \
  -repo=${REPO} \
  -user=${USER} \
  -pass=${PASSWORD} \
  -dir=${DIRECTORY} \
  -trans=tr_delete_old_ee_repo \
  -param:PARAM_DI_SERVER_USER=${USER} \
  -param:PARAM_DI_SERVER_PASSWORD=${PASSWORD} \
  -param:PARAM_DI_SERVER_HOST=${HOST} \
  -param:PARAM_DI_SERVER_PORT=${PORT} \
  -param:PARAM_DI_SERVER_DEPLOYMENT_PATH=${DEPLOYMENT_PATH}