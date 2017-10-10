#!/bin/bash

function createConfigFiles {
# expected setup
# ${PATH_TO_FILE}: path to file, not including file name
# ${FILE_NAME}: template file
# ${FILE_NAME}.config: specifying the environment variables to map to 

  mkdir -p /tmp/psgrs

  # config files are all stored inside the config folder, 
  # so that they are easily accessible be end users
  # the templates are located somewhere in the artefacts folder
  source config/${FILE_NAME}.config 
  envsubst < ${FILE_NAME} > /tmp/psgrs/${FILE_NAME}

}