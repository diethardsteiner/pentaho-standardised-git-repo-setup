#!/bin/bash
echo "Starting WebSpoon ..."
echo ""
echo "Mapping following local Kettle Home folder to a Docker Volume:"
echo "$KETTLE_HOME"
echo ""
echo "IMPORTANT: If you use the file-based repo, "

# Get path to current git repo root
## [OPEN] In prod env this will not necessarily be within a git repo
## since it might be deployed by other means, so we cannot use the git command!
PROJECT_GIT_DIR=`git rev-parse --show-toplevel`
# Extract project name and environment from the standardised project folder name
# The folder name gets initially standardised by the `initialise-repo.sh`
# Get last `/` and apply substring from there to the end
PROJECT_GIT_FOLDER=${PROJECT_GIT_DIR##*/}
# Get substring from first character to first `-`
PROJECT_NAME=${PROJECT_GIT_FOLDER%%-*}
# Get substring from last `-` to the end
PDI_ENV=${PROJECT_GIT_FOLDER##*-}
# Path to the root directory where the common and project specific git repos are stored in
BASE_DIR=${PROJECT_GIT_DIR%/*}
# build path for project code dir
PROJECT_CODE_DIR=${PROJECT_GIT_DIR%%-*}-code
# path to di files root dir - used for file-based pdi approach 
PROJECT_CODE_PDI_REPO_DIR=${PROJECT_CODE_DIR}/pdi/repo


echo "Mapping following local repo folder to a Docker Volume:"
echo "$PROJECT_CODE_PDI_REPO_DIR"
echo "IMPORTANT: If using file-based setup, the files will be"
echo "available under /root/repo when accessed via WebSpoon."


sudo docker run -it --rm \
  -e JAVA_OPTS="-Xms1024m -Xmx2048m" \
  -p 8080:8080 \
  -v ${KETTLE_HOME}/.kettle:/root/.kettle:z \
  -v ${KETTLE_HOME}/.pentaho:/root/.pentaho:z \
  -v ${PROJECT_CODE_PDI_REPO_DIR}:/root/repo:z \
  hiromuhota/webspoon:latest-full

# OPEN: Instead of including the pdi repo dir we could include the whole code git repo