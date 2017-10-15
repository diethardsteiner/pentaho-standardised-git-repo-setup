#!/bin/bash
## File-Based Repo Details ##
PARAM_FB_PDI_REPO_USER=admin
PARAM_FB_PDI_REPO_PASSWORD=password
PARAM_FB_PDI_REPO_NAME=
# repo location of the job
PARAM_FB_PDI_CI_DIR=/modules/continuous_integration
# where to store the exported xml on the file system
PARAM_FB_REPO_EXPORT_FILE_LOCATION=/tmp/fb-repo-export.xml
## EE Repo Details ##
PARAM_EE_PDI_REPO_USER=admin
PARAM_EE_PDI_REPO_PASSWORD=password
PARAM_EE_PDI_REPO_NAME=pentaho-di
PARAM_EE_PDI_REPO_PATH_PREFIX=/home/projectx
## DI Server Details ##
PARAM_DI_SERVER_HOST=
PARAM_DI_SERVER_PORT=
# depending on server version set to `pentaho` or `pentaho-di`
PARAM_DI_SERVER_WEB_APP_NAME=pentaho-di
# comment that should be added to the ee repo once upload is complete
PARAM_COMMENT=latest-and-greatest