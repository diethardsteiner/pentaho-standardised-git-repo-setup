#!/bin/bash

read REPO USER PASSWORD DIRECTORY FILE RULE COMMENT

cd ${PDI_DIR}

# the rules file is optional
RULES_FILE=

echo all | 
  ./import.sh \
    -repo=${REPO} \
    -user=${USER} \
    -pass=${PASSWORD} \
    -dir=${DIRECTORY} \
    -file=${FILE} \
    -replace=true \
    -coe=false \
    -comment=${COMMENT}