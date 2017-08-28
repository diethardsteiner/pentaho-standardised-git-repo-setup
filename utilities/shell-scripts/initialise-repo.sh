#!/bin/bash

WORKING_DIR=`pwd`
SHELL_DIR=$(dirname $0)
BASE_DIR=${WORKING_DIR}



# ========== ORGANISATION SPECFIC CONFIGURATION PROPERTIES =========== #

## ~~~~~~~~~~~~~~~~~ AMEND FOR YOUR ORANGISATION ~~~~~~~~~~~~~~~~~~~~~##
##                      ______________________                        ##

# The SSH or HTTPS URL to clone the modules repo
MODULES_GIT_REPO_URL=git@github.com:diethardsteiner/pentaho-pdi-modules.git
# **Note**: If this repo is not present yet, use this script 
# to create it and push it to your Git Server (GitHub, etc).

## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##


echo "=============="
echo "SHELL DIR: " ${SHELL_DIR}
echo "BASE_DIR: " ${BASE_DIR}


## Ask for required parameters
# if [ $# -eq 0 ] || [ -z "$1" ] #|| [ -z "$2" ] || [ -z "$3" ]
#   then
#     echo "ERROR: Not all mandatory arguments supplied, please supply environment and/or job arguments"
#     echo
#     echo "Usage: initialise-code-repo.sh [PROJECT NAME] [ENVIRONMENT NAME] [BASE DIRECTORY]"
#     echo "Creates a basic folder structure for a code repository"
#     echo 
#     echo "Mandatory arguments"
#     echo
#     echo "ACTION: Choose number"
#     echo " (1) Project Repo with Common Config and Modules"
#     echo "  pdi-module"
#     echo "  pdi-module-repo"
#     echo "  project-code"
#     echo "  project-config"
#     echo "  common-code"
#     echo "  common-config"
#     echo "  project-docu"
#     echo "  common-docu"
#     echo " "
#     echo "ENVIRONMENT NAME: The name of the environment (e.g. dev, test, ...)"
#     echo "PROJECT NAME:     The name of the project"
#     echo "exiting ..."
#     exit 1
#   else
#     # project name
#     PROJECT_NAME="$3"
#     echo "PROJECT NAME: ${PROJECT_NAME}"
#     # environment name
#     PDI_ENV="$3"
#     echo "ENV: ${PDI_ENV}"
#     # base directory
#     ACTION="$1"
#     echo "ACTION: " ${ACTION}
#     BASE_DIR=${WORKING_DIR}
#     echo "BASE DIRECTORY: ${BASE_DIR}"
# fi

if [ $# -eq 0 ] || [ -z "$1" ]
  then
    echo "ERROR: Not all mandatory arguments supplied, please supply environment and/or job arguments"
    echo
    echo "Usage: initialise-code-repo.sh ..."
    echo "Creates a basic folder structure for a code repository"
    echo 
    echo "Mandatory arguments"
    echo
    echo "-a   ACTION: Choose number"
    echo "        (1) Project Repo with Common Config and Modules"
    echo "        pdi-module"
    echo "        pdi-module-repo"
    echo "        project-code"
    echo "        project-config"
    echo "        common-code"
    echo "        common-config"
    echo "        project-docu"
    echo "        common-docu"
    echo "exiting ..."
    exit 1
fi


# while getopts ":a:p:d:u:" opt; do
while getopts ":a:p:d:" opt; do
  case $opt in
    a) ACTION="$OPTARG"
    ;;
    p) PROJECT_NAME="$OPTARG"
    # [OPEN] Check that project name has letters only, no dashes etc!
    ;;
    e) PDI_ENV="$OPTARG"
    ;;
    # u) MODULES_GIT_REPO_URL="$OPTARG"
    # ;;
    \?) 
      echo "Invalid option -$OPTARG" >&2
      exit 1
    ;;
  esac
done

# Example Usage:
# ./utilities/shell-scripts/initialise-repo.sh -a"pdi-module-repo"


function pdi-module {
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

function pdi-module-repo {
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

function project-code {
  # [OPEN] we need a version for the non-repo based setup
  echo "================PROJECT CODE===================="
  PROJECT_CODE_DIR=${BASE_DIR}/${PROJECT_NAME}
  echo "PROJECT_CODE_DIR: ${PROJECT_CODE_DIR}"
  if [ ! -d "${PROJECT_CODE_DIR}" ]; then
    echo "Creating project code folder ..."
    echo "location: ${PROJECT_CODE_DIR}" 
    mkdir ${PROJECT_CODE_DIR}
    cd ${PROJECT_CODE_DIR}
    echo "Initialising Git Repo ..."
    git init .
    echo "Creating Git Branch ${PDI_ENV} ..."
    git checkout -b ${PDI_ENV}
    echo "Creating basic folder structure ..."
    mkdir etl mdx mondrian-schemas pentaho-solutions sql
    echo "Creating basic README file ..."
    echo "Documentation can be found in the dedicated documentation Git repo called ${PROJECT_NAME}-documentation" > README.md
    echo "Adding kettle db connection files ..."
    cp -r ${SHELL_DIR}/artefacts/pdi/repo/*.kdb etl
    echo "Adding pdi modules as a git submodule ..."
    git submodule add -b master ${MODULES_GIT_REPO_URL} modules
    git submodule init
    git submodule update
  fi
}

function project-config {
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
    cd ${WORKING_DIR}
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

function standalone-project-config {
  project-config()
  echo "Adding essential shell files ..."
  cp ${SHELL_DIR}/artefacts/common-config/*.sh ${COMMON_CONFIG_DIR}/shell-scripts
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

function common-config {
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
    echo "Adding .kettle folder ..."
    cp -r ${SHELL_DIR}/artefacts/pdi/.kettle .
    # [OPEN] repository.xml template has to be populated with real values
    echo "Adding essential shell files ..."
    cp ${SHELL_DIR}/artefacts/common-config/*.sh ${COMMON_CONFIG_DIR}/shell-scripts
    echo "Creating basic README file ..."
    echo "Common configuration for ${PDI_ENV} environment." > ${COMMON_CONFIG_DIR}/README.md
  fi
}


function project-docu {
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

function common-docu {
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
  pdi-module
  pdi-module-repo
  project-code
  project-config
  common-config
  common-docu
  project-docu
fi

if [ ${ACTION} = "pdi-module" ]; then 
  pdi-module
fi

if [ ${ACTION} = "pdi-module-repo" ]; then
  pdi-module-repo
fi

if [ ${ACTION} = "project-code" ]; then
  project-code
fi

if [ ${ACTION} = "project-config" ]; then
  project-config
fi

if [ ${ACTION} = "common-config" ]; then
  common-config
fi

if [ ${ACTION} = "project-docu" ]; then
  project-docu
fi

if [ ${ACTION} = "common-docu" ]; then
  common-docu
fi