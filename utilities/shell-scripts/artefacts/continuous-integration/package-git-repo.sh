#!/bin/bash

# expects: RELEASE_NAME, TAG, WORK_DIR, PACKAGE_NAME, PREFIX

# create dedicated release branch based on dev branch
git checkout -b release_{RELEASE_NAME} dev
git tag ${TAG}
git push --tags
git archive ${TAG} -v -o ${WORK_DIR}/${PACKAGE_NAME}.zip --prefix="${PREFIX}/"