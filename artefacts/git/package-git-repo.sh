#!/bin/bash

# expects:
# - GIT_DIR: location of the git repo you want to package
# - VERSION: git tag 
# - PREFIX 
# - PACKAGE_FILE_PATH: path to and filename of package file

#read GIT_DIR VERSION PREFIX PACKAGE_FILE_PATH
GIT_DIR=$1
VERSION=$2
PREFIX=$3
PACKAGE_FILE_PATH=$4

echo "Following parameter values were passed:"
echo "GIT_DIR: ${GIT_DIR}"
echo "VERSION: ${VERSION}"
echo "PREFIX:  ${PREFIX}"
echo "PACKAGE_FILE_PATH: ${PACKAGE_FILE_PATH}"

# -----------------
# EXAMPLE USAGE: ./package-git-repo.sh /tmp/test/mysampleproj-code 0.1 mysampleproj-code /tmp/mysampleproj-code.tar
# -----------------

cd ${GIT_DIR}

# Adding version number to prefix might be a good idea since you can easily roll
# back then. On target system you can use a sym link to abstract this.

TAG=`git tag | grep ${VERSION}`
if [ ${TAG}="" ]; then
  echo "Warning: ${VERSION} does not exist. Using last commit instead."
  LAST_COMMIT_ID=`git log --format="%H" -n 1`
  TAG=${LAST_COMMIT_ID}
fi

git archive --prefix=${PREFIX}-${TAG}/ -o ${PACKAGE_FILE_PATH} ${TAG}

# create folder to store tmp tar files if it doesn't exist already
if [ ! -d "${GIT_DIR}/rpmbuild" ]; then
  echo "Creating tmp dir ${GIT_DIR}/rpmbuild ..."
  mkdir ${GIT_DIR}/rpmbuild
fi

echo "Following version was used for the package:" > ${GIT_DIR}/rpmbuild/MANIFEST-REPOS.md
echo "main module tag/commit id: ${TAG}" >> ${GIT_DIR}/rpmbuild/MANIFEST-REPOS.md

# FETCH SUBMODULE CODE

# pipe the output of the git submodule foreach command into a while loop
(echo .; git submodule foreach) | \
# the previous command retruns something like `Entering etl/modules`
# we are only interested in the latter part
while read ENTERING PATH_SUBMODULE; do
  # get rid of the enclosing single quotation marks
  TEMP_PATH_SUBMODULE="${PATH_SUBMODULE%\'}"
  TEMP_PATH_SUBMODULE="${TEMP_PATH_SUBMODULE#\'}"
  PATH_SUBMODULE=${TEMP_PATH_SUBMODULE}
  # check there is actually a path value available
  if [ ! "${PATH_SUBMODULE}" = "" ]; then
    echo "Submodule found: ${PATH_SUBMODULE}"
    echo "Changing to following submodule dir: ${GIT_DIR}/${PATH_SUBMODULE}"
    # change to submodule folder
    cd ${GIT_DIR}/${PATH_SUBMODULE}
    # Run a normal git archive command
    # Create a plain uncompressed tar archive in a temporary director
    LAST_COMMIT_ID_SUBMODULE=`git log --format="%H" -n 1`
    echo "Packaging Submodule ..."
    git archive --prefix=${PREFIX}-${TAG}/${PATH_SUBMODULE}/ ${LAST_COMMIT_ID_SUBMODULE} > ${GIT_DIR}/rpmbuild/tmp.tar
    # Add the temporary submodule tar file to the existing project tar file
    echo "Adding Submodule package to Main package ..."
    tar --concatenate --file=${PACKAGE_FILE_PATH} ${GIT_DIR}/rpmbuild/tmp.tar
    # Remove temporary tar file
    rm ${GIT_DIR}/rpmbuild/tmp.tar
    echo "submodule ${PATH_SUBMODULE} tag/commit id: ${LAST_COMMIT_ID_SUBMODULE}" >> ${GIT_DIR}/rpmbuild/MANIFEST-REPOS.md
 fi
done

# ADD THE MANIFEST
# using the -C flag to change to the directory where the file is in
# so that it is placed in the root directory of our file 
echo "Adding Repo Manifest to Main package ..."
    tar --append --file=${PACKAGE_FILE_PATH} -C ${GIT_DIR}/rpmbuild MANIFEST-REPOS.md


function git_root {
  git rev-parse --show-toplevel
}

# create a manifest for files of main repo only (no submodules)
cd `git_root`
git ls-tree -r ${TAG} --abbrev > ${GIT_DIR}/rpmbuild/MANIFEST.md

echo "Adding File Manifest to Main package ..."
    tar --append --file=${PACKAGE_FILE_PATH} -C ${GIT_DIR}/rpmbuild MANIFEST.md

# ADD CHANGELOG


cd `git_root`
# get commit id from first commit
TAG_FROM=$(git log --format="%H" | head -n2 | tail -n1) 
TAG_TO=${TAG}
TEMP=`mktemp`

# Append the new log to the top of the changelog file
echo -e "# Version ${TAG_TO}\n=============" > ${GIT_DIR}/rpmbuild/CHANGELOG.md
echo "Showing changes from: ${TAG_FROM}" >> ${GIT_DIR}/rpmbuild/CHANGELOG.md
CHANGELOG=$(git log $TAG_FROM..$TAG_TO --no-merges --sparse --date='format-local:%Y-%m-%d %H:%M:%S' --pretty=format:"%ad %<(20,trunc)%aN %s" | sed -e 's/_/\\_/g')
echo ${CHANGELOG} >> ${GIT_DIR}/rpmbuild/CHANGELOG.md

echo "Adding File Manifest to Main package ..."
    tar --append --file=${PACKAGE_FILE_PATH} -C ${GIT_DIR}/rpmbuild CHANGELOG.md

# Remove temporary files
if [ -d "${GIT_DIR}/rpmbuild" ]; then
  echo "Reomoving tmp dir ${GIT_DIR}/rpmbuild ..."
  rm -r ${GIT_DIR}/rpmbuild
fi

# build RPM

PSGRS_RPM_DIR=/tmp/psgrs

mkdir ${PSGRS_RPM_DIR}
cd ${PSGRS_RPM_DIR}
# create minimum required folders
mkdir SOURCES SPECS # BUILD RPMS SRPMS
cd SOURCES
# copy tar file into source folder
cp ${PACKAGE_FILE_PATH} .