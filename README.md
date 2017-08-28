# pentaho-standardised-git-repo-setup


## Initial Setup

The `utilities` git repo is provide as a template. You will have to change a few configuration details to make it fit within your organisation. Once you have made these changes, you have to make it available via a Git Server/Web Frontend like **Github**, **GitLab**, **Bitbucket** or similar. From there, anyone who wants to create a new Git project within your organisation, can clone this pre-configured `utilities` repo and run the `initialise-repo.sh` script located within it, which will set up the basic git folder structure.

You have to change the following in the utilities folder:

- `shell-scripts/initialise-repo.sh`: There is only one parameter to define called `MODULES_GIT_REPO_URL`, which is the **SSH** or **HTTPS** URL to clone the **modules repo**. 

> **Note**: If this repo is not present yet, use the `shell-scripts/initialise-repo.sh` to create it and push it to your Git Server (GitHub, etc). Then adjust the configuration.

- `shell-scripts/project-config/wrapper.sh`: There are only changes required in the `PROJECT-SPECIFIC CONFIGURATION PROPERTIES` section.

## Initialise Project Structure

Clone the `utilities` repo. Inside the `shell-script` folder, you can find a script called `initialise-repo.sh`, which can create:

- project-specific **config repo** for a given environment 
- common **config repo** for a given environment 
- common **code repo**
- project **code repo**
- common **docu repo**
- project **docu repo** 
- PDI module
- PDI module repo 
 
with the very basic folder structure and required artifacts. The script enables you to create them individually or combinations of certain repositories.

The `initialise-repo.sh` script expects following **arguments**:

- action (required)
- project name (not always required)
- environment (not always required)
- PDI file storage (not always required)

> **Important**: The project name must only include letters, no other characters. The same applies to the environment name.


> **Important**: All the repositories have to be located within the same folder. This folder is referred to as `BASE_DIR`.

## Example

Creating a new **project** called `myproject` with **common artefacts** for the `dev` **environment** using a PDI file-based **storage approach** 

```bash
$ sh ./utilities/shell-scripts/initialise-repo.sh -a 1 -p myproject -e dev -s files
Submitted action value: 1
Submitted project name value: myproject
Submitted environment value: dev
==============
SHELL DIR:  /home/dsteiner/git/pentaho-standardised-git-repo-setup//utilities/shell-scripts
BASE_DIR:  /tmp/test
================PROJECT CODE====================
PROJECT_CODE_DIR: /tmp/test/myproject
Creating project code folder ...
location: /tmp/test/myproject
Initialising Git Repo ...
Initialized empty Git repository in /tmp/test/myproject/.git/
Creating Git Branch dev ...
Switched to a new branch 'dev'
Creating basic folder structure ...
Creating basic README file ...
Adding kettle db connection files ...
Adding pdi modules as a git submodule ...
Cloning into '/tmp/test/myproject/modules'...
remote: Counting objects: 3, done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (3/3), done.
================PROJECT CONFIG==================
PROJECT_CONFIG_DIR: /tmp/test/myproject-config-dev
Creating project config folder ...
location: /tmp/test/myproject-config-dev
Initialising Git Repo ...
Initialized empty Git repository in /tmp/test/myproject-config-dev/.git/
Creating basic folder structure ...
Adding essential shell files ...
Adding essential properties files ...
Creating basic README file ...
==========COMMON CONFIG==================
COMMON_CONFIG_DIR: /tmp/test/common-config-dev
Creating common config folder ...
location: /tmp/test/common-config-dev
Creating basic folder structure ...
Initialising Git Repo ...
Initialized empty Git repository in /tmp/test/common-config-dev/.git/
Adding .kettle folder ...
Adding essential shell files ...
Creating basic README file ...
===========COMMON DOCUMENTATION==================
COMMON_DOCU_DIR: /tmp/test/common-documentation
Creating project documentation folder ...
location: /tmp/test/common-documentation
Initialising Git Repo ...
Initialized empty Git repository in /tmp/test/common-documentation/.git/
Creating basic README file ...
===========PROJECT DOCUMENTATION==================
PROJECT_DOCU_DIR: /tmp/test/myproject-documentation
Creating project documentation folder ...
location: /tmp/test/myproject-documentation
Initialising Git Repo ...
Initialized empty Git repository in /tmp/test/myproject-documentation/.git/
Creating basic README file ...
```

This will create the following structure:

```bash
.
├── common-config-dev
│   ├── .git
│   ├── .kettle
│   │   ├── kettle.properties
│   │   └── repositories.xml
│   ├── README.md
│   └── shell-scripts
│       └── set_env_variables.sh
├── common-documentation
│   ├── .git
│   └── README.md
├── myproject
│   ├── etl
│   │   └── db_connection_template.kdb
│   ├── .git
│   ├── .gitmodules
│   ├── mdx
│   ├── modules
│   │   ├── .git
│   │   └── README.md
│   ├── mondrian-schemas
│   ├── pentaho-solutions
│   ├── README.md
│   └── sql
├── myproject-config-dev
│   ├── .git
│   ├── properties
│   │   ├── jb_myproject_master.properties
│   │   └── myproject.properties
│   ├── README.md
│   └── shell-scripts
│       ├── run_jb_myproject_master.sh
│       └── wrapper.sh
└── myproject-documentation
    ├── .git
    └── README.md
```

Once this is in place, you have to change the following:

- `common-config-<env>/.kettle/kettle.properties`
- `common-config-<env>/.kettle/repositories.xml` (only when using repo storage mode): Set the path to the PDI repository of your project (located in `myproject/etl`)
- `common-config-<env>/shell-scripts/set_env_variables.sh`
- `myproject-config-<env>/shell-scripts/wrapper.sh`

If you are setting this up on your local workstation, you should be able to start Spoon now and connect to the PDI repository. You have to run this first before opening Spoon from the same terminal session (adjust as required):

```bash
common-config-<env>/shell-scripts/set_env_variables.sh
```

As the next step you might want to adjust:

- `common-config-<env>/.kettle/shared.xml` (only when using file-based storage mode)
- `myproject-config-<env>/properties/myproject.properties`
- `myproject-config-<env>/properties/jb_myproject_master.properties`