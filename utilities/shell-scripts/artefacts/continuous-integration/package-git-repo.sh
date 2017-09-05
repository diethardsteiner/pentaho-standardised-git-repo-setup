#!/bin/bash

# expects:
# - VERSION: git tag 
# - PREFIX 
# - PACKAGE_FILE_PATH: path to and filename of package file

while read VERSION PREFIX PACKAGE_FILE_PATH
# ./package-git-repo.sh 0.1 myproject /tmp/myproject

# create dedicated release branch based on dev branch
# git checkout -b release_${VERSION} dev
# git tag ${VERSION}
# git push --tags
# git archive ${VERSION} -v -o ${PACKAGE_FILE_PATH}.zip --prefix="${PREFIX}/"

# inlude submodules
# based on https://ttboj.wordpress.com/2015/07/23/git-archive-with-submodules-and-tar-magic/


# OPEN: Adding version number to prefix might be a good idea since you can easily roll
# back then. On target system you can use a sym link to abstract this.
git archive --prefix=${PREFIX}-${VERSION}/ -o ${PACKAGE_FILE_PATH} ${VERSION} \
  2> /dev/null || \
  (echo "Warning: ${VERSION} does not exist." && \
  # if version does not exist checkout head
  git archive --prefix=${PREFIX}-${VERSION}/ -o ${PACKAGE_FILE_PATH} HEAD)

# save current working directory in var for later use
P=`pdw` && \
# pipe the output of the git submodule foreach command into a while loop
(echo .; git submodule foreach) | \
# the previous command retruns something like `Entering etl/modules`
# we are only interested in the latter part
# we simply treat them as different parameters and only use the last one
while read ENTERING PATH; do \
  # get rid of the enclosing single quotation marks
  TEMP="${PATH%\'}"; \
  TEMP="${TEMP#\'}"; \
  PATH=${TEMP}; \
  # check there is actually a path value available
  [ "${PATH}" = "" ] && continue; \
  # create folder to store tmp tar files if it doesn't exist already
  [ ! -d "${P}/rpmbuild" ] && mkdir ${P}/rpmbuild;
  # change to submodule folder
  (cd ${PATH} && \
  # Run a normal git archive command
  git archive --prefix=${PREFIX}/${PATH}/ HEAD \
  # Create a plain uncompressed tar archive in a temporary director
  > ${P}/rpmbuild/tmp.tar && \
  # Add the temporary submodule tar file to the existing project tar file
  tar --concatenate --file=${P}/${PACKAGE_FILE_PATH} ${P}/rpmbuild/tmp.tar && \
  #  Remove temporary tar file
  rm $P/rpmbuild/tmp.tar); \
done