#!/bin/bash


# ========== ORGANISATION SPECFIC CONFIGURATION PROPERTIES =========== #

## ~~~~~~~~~~~~~~~~~ AMEND FOR YOUR ORANGISATION ~~~~~~~~~~~~~~~~~~~~~##
##                      ______________________                        ##

# The SSH or HTTPS URL to clone the modules repo
MODULES_GIT_REPO_URL=git@github.com:diethardsteiner/pentaho-pdi-modules.git
# **Note**: If this repo is not present yet, use this script 
# to create it and push it to your Git Server (GitHub, etc).

## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##



## ~~~~~~~~~~~~~~~~~~~~~~~~~ DO NOT CHANGE ~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##                      ______________________                        ##


if [ $# -eq 0 ] || [ -z "$1" ]
  then
    echo "ERROR: Not all mandatory arguments supplied, please supply environment and/or job arguments"
    echo
    echo "Usage: initialise-repo.sh ..."
    echo "Creates a basic folder structure for a code repository"
    echo 
    echo "Mandatory arguments"
    echo
    echo "-a   ACTION: Choose number"
    echo "        (1) Project Repo with Common Config and Modules"
    echo "        pdi_module"
    echo "        pdi_module_repo"
    echo "        project_code"
    echo "        project_config"
    echo "        standalone_project_config"
    echo "        common_code"
    echo "        common_config"
    echo "        project_docu"
    echo "        common_docu"
    echo " "
    echo "Optional arguments:"
    echo " "
    echo "-p  PROJECT NAME:  Lower case, only letters allowed, no underscores, dashes etc."
    echo "                   Minimum of 3 to a maximum of 20 letters."
    echo "-e  ENVIRONMENT:   Name of the environment: dev, test, prod or similiar. "
    echo "                   Lower case, only letters allowed, no underscores, dashes etc"
    echo "                   Minimum of 3 to a maximum of 10 letters."
    echo "-s  STORAGE TYPE:  Which type of PDI storage type to use."
    echo "                   Possible values: file-based, file-repo. Not supported: db-repo, ee-repo"
    echo "exiting ..."
    exit 1
fi


# while getopts ":a:p:d:u:" opt; do
while getopts ":a:p:e:s:" opt; do
  case $opt in
    a) ACTION="$OPTARG"
        echo "Submitted action value: ${ACTION}"
    ;;
    p) PROJECT_NAME="$OPTARG"
        echo "Submitted project name value: ${PROJECT_NAME}"
        if [[ ! ${PROJECT_NAME} =~ ^[a-z]{3,20}$ ]]; then
          echo "Unsupported project name!"
          echo "Lower case, only letters allowed, no underscores, dashes, spaces etc."
          echo "Minimum of 3 to a maximum of 20 letters."
          exit 1
        fi
    ;;
    e) PDI_ENV="$OPTARG"
        echo "Submitted environment value: ${PDI_ENV}" 
        if [[ ! ${PDI_ENV} =~ ^[a-z]{3,10}$ ]]; then
          echo "Unsupported environment name!"
          echo "Lower case, only letters allowed, no underscores, dashes, spaces etc."
          echo "Minimum of 3 to a maximum of 10 letters."
          exit 1
        fi
    ;;
    s) PDI_STORAGE_TYPE="$OPTARG"
        echo "Submitted environment value: ${PDI_STORAGE_TYPE}" 
        # check that supplied value is in the list of possible values
        # validate() { echo "files file-repo ee-repo" | grep -F -q -w "${PDI_STORAGE_TYPE}"; }
        LIST_CHECK=$(echo "file-based file-repo ee-repo" | grep -F -q -w "${PDI_STORAGE_TYPE}" && echo "valid" || echo "invalid")
        echo "List check: ${LIST_CHECK}"
        if [ ${LIST_CHECK} = "invalid" ]; then
          echo "Unsupported storage type!"
          echo "Possible values: file-based, file-repo, ee-repo"
          exit 1
        fi
    ;;
    \?) 
      echo "Invalid option -$OPTARG" >&2
      exit 1
    ;;
  esac
done

# Example Usage:
# ./utilities/shell-scripts/initialise-repo.sh -a project_code -p mysampleproj -e dev 


# Source required helper scripts

source ./add-pdi-respository.sh

# Main Script

WORKING_DIR=`pwd`
SHELL_DIR=$(dirname $0)
BASE_DIR=${WORKING_DIR}

echo "=============="
echo "SHELL DIR: " ${SHELL_DIR}
echo "BASE_DIR: " ${BASE_DIR}



function pdi_module {
  # check if required parameter values are available
  if [ -z ${ACTION} ]; then
    echo "Not all required arguments were supplied. Required:"
    echo "-a <Action>"
    echo "exiting ..."
    exit 1
  fi
  echo "================PDI MODULES===================="
  PDI_MODULES_DIR=${BASE_DIR}/modules
  echo "PDI_MODULES_DIR: ${PDI_MODULES_DIR}" 
  if [ ! -d "${PDI_MODULES_DIR}" ]; then
    echo "Creating PDI modules folder ..."
    mkdir ${PDI_MODULES_DIR}
    cd ${PDI_MODULES_DIR}
    echo "Initialising Git Repo ..."
    git init .
    # we have to create a file so that the master branch is created
    echo "creatng README file ..."
    touch README.md
    echo "adding module_1 sample module ..."
    cp -r ${SHELL_DIR}/artefacts/pdi/repo/module_1 .
    git add --all
    git commit -am "initial commit"
  fi
}

function pdi_module_repo {
  # check if required parameter values are available
  if [ -z ${ACTION} ]; then
    echo "Not all required arguments were supplied. Required:"
    echo "-a <Action>"
    echo "exiting ..."
    exit 1
  fi
  echo "================PDI MODULES REPO===================="
  PDI_MODULES_REPO_DIR=${BASE_DIR}/modules-pdi-repo
  echo "PDI_MODULES_REPO_DIR: ${PDI_MODULES_REPO_DIR}"
  if [ ! -d "${PDI_MODULES_REPO_DIR}" ]; then
    echo "Creating PDI modules repo folder ..."
    mkdir ${PDI_MODULES_REPO_DIR}
    echo "Initialising Git Repo ..."
    cd ${PDI_MODULES_REPO_DIR}
    git init .
    echo "Adding kettle db connection files ..."
    cp -r ${SHELL_DIR}/artefacts/pdi/repo/*.kdb .
    echo "Adding pdi modules as a git submodule ..."
    git submodule add -b master ${MODULES_GIT_REPO_URL} modules
    # the next command is only required in older git versions to get the content for the submodule
    git submodule init
    git submodule update
  fi 
}

function project_code {
  # check if required parameter values are available
  if [ -z ${ACTION} ] || [ -z ${PROJECT_NAME} ] || [ -z ${PDI_STORAGE_TYPE} ]; then
    echo "Not all required arguments were supplied. Required:"
    echo "-a <Action>"
    echo "-p <Project Name>"
    echo "-s <PDI Storage Type>"
    echo "exiting ..."
    exit 1
  fi
  echo "================PROJECT CODE===================="
  PROJECT_CODE_DIR=${BASE_DIR}/${PROJECT_NAME}-code
  echo "PROJECT_CODE_DIR: ${PROJECT_CODE_DIR}"
  if [ ! -d "${PROJECT_CODE_DIR}" ]; then
    echo "Creating project code folder ..."
    echo "location: ${PROJECT_CODE_DIR}" 
    mkdir ${PROJECT_CODE_DIR}
    cd ${PROJECT_CODE_DIR}
    echo "Initialising Git Repo ..."
    git init .
    echo "Creating essential branches ..."
    git branch dev
    # not creating feature or release branches since there can be many of them
    echo "Pointing to default git branch"
    git checkout dev
    echo "Creating Git Branch ${PDI_ENV} ..."
    git checkout -b ${PDI_ENV}
    echo "Creating basic folder structure ..."
    mkdir etl mdx mondrian-schemas pentaho-solutions sql
    echo "Creating basic README file ..."
    echo "Documentation can be found in the dedicated documentation Git repo called ${PROJECT_NAME}-documentation" > README.md
    if [ ${PDI_STORAGE_TYPE} = "file-repo" ]; then
      echo "Adding kettle db connection files ..."
      cp -r ${SHELL_DIR}/artefacts/pdi/repo/*.kdb etl
    fi
    if [ ${PDI_STORAGE_TYPE} = "file-based" ]; then
      # nothing to do: shared.xml is part of .kettle, which lives in the config
      echo ""
    fi
    echo "Adding pdi modules as a git submodule ..."
    git submodule add -b master ${MODULES_GIT_REPO_URL} modules
    git submodule init
    git submodule update
  fi
}

function project_config {
  # check if required parameter values are available
  if [ -z ${ACTION} ] || [ -z ${PROJECT_NAME} ] || [ -z ${PDI_ENV} ] || [ -z ${PDI_STORAGE_TYPE} ]; then
    echo "Not all required arguments were supplied. Required:"
    echo "-a <Action>"
    echo "-p <Project Name>"
    echo "-e <Environment>"
    echo "-s <PDI Storage Type>"
    echo "exiting ..."
    exit 1
  fi
  echo "================PROJECT CONFIG=================="
  PROJECT_CONFIG_DIR=${BASE_DIR}/${PROJECT_NAME}-config-${PDI_ENV}
  echo "PROJECT_CONFIG_DIR: ${PROJECT_CONFIG_DIR}"
  if [ ! -d "${PROJECT_CONFIG_DIR}" ]; then 
    echo "Creating project config folder ..."
    echo "location: ${PROJECT_CONFIG_DIR}" 
    mkdir ${PROJECT_CONFIG_DIR}
    cd ${PROJECT_CONFIG_DIR}
    echo "Initialising Git Repo ..."
    git init .
    echo "Creating basic folder structure ..."
    mkdir shell-scripts properties
    echo "Adding essential shell files ..."
    cp ${SHELL_DIR}/artefacts/project-config/*.sh ${PROJECT_CONFIG_DIR}/shell-scripts
    mv ${PROJECT_CONFIG_DIR}/shell-scripts/run_jb_name.sh ${PROJECT_CONFIG_DIR}/shell-scripts/run_jb_${PROJECT_NAME}_master.sh
    echo "Adding essential properties files ..."
    cp ${SHELL_DIR}/artefacts/project-config/*.properties ${PROJECT_CONFIG_DIR}/properties 
    mv ${PROJECT_CONFIG_DIR}/properties/project.properties ${PROJECT_CONFIG_DIR}/properties/${PROJECT_NAME}.properties
    touch ${PROJECT_CONFIG_DIR}/properties/jb_${PROJECT_NAME}_master.properties 
    echo "Creating basic README file ..."
    echo "Project specific configuration for ${PDI_ENV} environment." > ${PROJECT_CONFIG_DIR}/README.md  
  fi
}


function add_kettle_artefacts {
  echo "Adding .kettle files ..."
  ## !!! THE PROBLEM IS HERE - have to pass directory path
  mkdir .kettle
  cp ${SHELL_DIR}/artefacts/pdi/.kettle/kettle.properties .kettle
  # cp ${SHELL_DIR}/artefacts/pdi/.kettle/repositories.xml .kettle
  add_pdi_repository \
    -p ${PROJECT_NAME} \
    -b ${BASE_DIR}/${PROJECT_NAME}-code/etl \
    -b .kettle/repositories.xml
  if [ ${PDI_STORAGE_TYPE} = "files" ]; then
    cp ${SHELL_DIR}/artefacts/pdi/.kettle/shared.xml .kettle
  fi
}

function standalone_project_config {
  # This caters for projects that do not need a common project or config
  # check if required parameter values are available
  if [ -z ${ACTION} ] || [ -z ${PROJECT_NAME} ] || [ -z ${PDI_ENV} ] || [ -z ${PDI_STORAGE_TYPE} ]; then
    echo "Not all required arguments were supplied. Required:"
    echo "-a <Action>"
    echo "-p <Project Name>"
    echo "-e <Environment>"
    echo "-s <PDI Storage Type>"
    echo "exiting ..."
    exit 1
  fi
  project_config
  echo "Adding essential shell files ..."
  cp ${SHELL_DIR}/artefacts/common-config/*.sh ${COMMON_CONFIG_DIR}/shell-scripts
  add_kettle_artefacts
  # [OPEN] wrapper.sh has to be adjusted for standalone projects
}

# retired since we use modules now
# function common-code {
#   echo "==========COMMON CODE=================="
#   COMMON_CODE_DIR=${BASE_DIR}/common-code
#   if [ ! -d "${COMMON_CODE_DIR}" ]; then 
#     echo "Creating common config folder ..."
#     echo "location: ${COMMON_CODE_DIR}" 
#     mkdir ${COMMON_CODE_DIR}
#     cd ${COMMON_CODE_DIR}
#     echo "Initialising Git Repo ..."
#     git init .
#     echo "Creating Git Branch ${PDI_ENV} ..."
#     git checkout -b ${PDI_ENV}
#     echo "Creating basic folder structure ..."
#     mkdir etl mdx mondrian-schemas pentaho-solutions sql
#     echo "Creating basic README file ..."
#     echo "Common code for ${PDI_ENV} environment. Find documentation in dedicated docu repo." > ${COMMON_CODE_DIR}/README.md
#   fi
# }

function common_config {
  # check if required parameter values are available
  if [ -z ${ACTION} ] || [ -z ${PDI_ENV} ] || [ -z ${PDI_STORAGE_TYPE} ]; then
    echo "Not all required arguments were supplied. Required:"
    echo "-a <Action>"
    echo "-e <Environment>"
    echo "-s <PDI Storage Type>"
    echo "exiting ..."
    exit 1
  fi
  echo "==========COMMON CONFIG=================="
  COMMON_CONFIG_DIR=${BASE_DIR}/common-config-${PDI_ENV}
  echo "COMMON_CONFIG_DIR: ${COMMON_CONFIG_DIR}"
  if [ ! -d "${COMMON_CONFIG_DIR}" ]; then 
    echo "Creating common config folder ..."
    echo "location: ${COMMON_CONFIG_DIR}" 
    mkdir ${COMMON_CONFIG_DIR}
    cd ${COMMON_CONFIG_DIR}
    echo "Creating basic folder structure ..."
    mkdir shell-scripts
    echo "Initialising Git Repo ..."
    git init .
    add_kettle_artefacts
    # [OPEN] repository.xml template has to be populated with real values
    echo "Adding essential shell files ..."
    cp ${SHELL_DIR}/artefacts/common-config/*.sh ${COMMON_CONFIG_DIR}/shell-scripts
    echo "Creating basic README file ..."
    echo "Common configuration for ${PDI_ENV} environment." > ${COMMON_CONFIG_DIR}/README.md
  fi
}


function project_docu {
  # check if required parameter values are available
  if [ -z ${ACTION} ] || [ -z ${PROJECT_NAME} ]; then
    echo "Not all required arguments were supplied. Required:"
    echo "-a <Action>"
    echo "-p <Project Name>"
    echo "exiting ..."
    exit 1
  fi
  echo "===========PROJECT DOCUMENTATION=================="
  PROJECT_DOCU_DIR=${BASE_DIR}/${PROJECT_NAME}-documentation
  echo "PROJECT_DOCU_DIR: ${PROJECT_DOCU_DIR}"
  if [ ! -d "${PROJECT_DOCU_DIR}" ]; then 
    echo "Creating project documentation folder ..."
    echo "location: ${PROJECT_DOCU_DIR}"
    mkdir ${PROJECT_DOCU_DIR}
    cd ${PROJECT_DOCU_DIR}
    echo "Initialising Git Repo ..."
    git init .
    echo "Creating basic README file ..."
    echo "# Documentation for ${PROJECT_NAME}" > ${PROJECT_DOCU_DIR}/README.md
  fi
}

function common_docu {
  # check if required parameter values are available
  if [ -z ${ACTION} ]; then
    echo "Not all required arguments were supplied. Required:"
    echo "-a <Action>"
    echo "exiting ..."
    exit 1
  fi
  echo "===========COMMON DOCUMENTATION=================="
  COMMON_DOCU_DIR=${BASE_DIR}/common-documentation
  echo "COMMON_DOCU_DIR: ${COMMON_DOCU_DIR}"
  if [ ! -d "${COMMON_DOCU_DIR}" ]; then 
    echo "Creating project documentation folder ..."
    echo "location: ${COMMON_DOCU_DIR}"
    mkdir ${COMMON_DOCU_DIR}
    cd ${COMMON_DOCU_DIR}
    echo "Initialising Git Repo ..."
    git init .
    echo "Creating basic README file ..."
    echo "# Common Documentation" > ${COMMON_DOCU_DIR}/README.md
  fi
}



if [ ${ACTION} = "1" ]; then 
  ## [OPEN] check all required parameters are available!!!
  project_code
  project_config
  common_config
  common_docu
  project_docu
fi

if [ ${ACTION} = "pdi_module" ]; then 
  pdi_module
fi

if [ ${ACTION} = "pdi_module_repo" ]; then
  pdi_module_repo
fi

if [ ${ACTION} = "project_code" ]; then
  project_code
fi

if [ ${ACTION} = "project_config" ]; then
  project_config
fi

if [ ${ACTION} = "standalone_project_config" ]; then
  standalone_project_config
fi

if [ ${ACTION} = "common_config" ]; then
  common_config
fi

if [ ${ACTION} = "project_docu" ]; then
  project_docu
fi

if [ ${ACTION} = "common_docu" ]; then
  common_docu
fi