#!/bin/bash

read REPO USER PASSWORD DIRECTORY FILE RULE COMMENT

cd ${PDI_DIR}

# the rules file is optional
RULES_FILE=

# import.sh docu: http://wiki.pentaho.com/display/EAI/Import+User+Documentation
# The "Import" tool provides a command line interface for the import of transformations and jobs into a repository.
# => It not only supports the jackrabbit repos, but also file-based and DB repo types

echo all | 
  ./import.sh \
    # The name of the repository to import into
    -repo=${REPO} \ 
    -user=${USER} \
    -pass=${PASSWORD} \
    # The name of the repository to import into
    -dir=${DIRECTORY} \
    # An optional list of comma separated source directories to limit the import to 
    -limitdir= ${} \
    # The path to the export file that needs to be imported (optional, you can also specify a list of files after the other options)
    -file=${FILE} \ 
    # Set to Y to replace existing transformations and jobs in the repository, defaults to N
    -replace=true \
    # Continue on error.  Warning, use with caution as this will ignore validation errors!
    -coe=false \
    # The comment that will be set for the new revisions of the transformations and jobs caused by the import.
    -comment=${COMMENT}