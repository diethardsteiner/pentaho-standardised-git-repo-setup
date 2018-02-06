# Getting Started

## Purpose

To understand what the project is about, have a look at the presentation in this repos' [presentation](./presentations/pcm2017.md). Read this before proceeding.

> **In a nutshell**: This project delivers a utility script which sets up potentially several Pentaho specific git repos with a predefined/standardised folder structure and utilises Git Hooks to enforce a few coding standards.

## Initial Setup


Clone the repo to your local machine: 

```bash 
git clone git@github.com:diethardsteiner/pentaho-standardised-git-repo-setup.git
cd pentaho-standardised-git-repo-setup
```

Next have to change the following file **for each project and environment** that you want to create the git skeleton for:

- `config/settings.sh`: Read comments in file to understand what the settings mean.

> **Note** on `MODULES_GIT_REPO_URL`: If you do not have a repo yet for the PDI modules (reusable code), use the `initialise-repo.sh` to create it and push it to your Git Server (GitHub, etc). Then adjust the configuration.

There are also some artefacts that are corrently not controlled by the central settings file, e.g. Spoon settings, located in:

```
aretefacts/pdi/.kettle/.spoonrc
```


## Initialise Project Structure

The `initialise-repo.sh` can create:

- project-specific **config repo** for a given environment (`<proj>-conf-<env>`)
- common **config repo** for a given environment (`common-conf-<env>`)
- project **code repo** (`<proj>-code`)
- common **docu repo** (`common-documentation`)
- project **docu repo** (`<proj>-documentation`)
- PDI **modules** (`modules`): for reusable code/patterns. Holds plain modules only, so it can be use either in file-based or repo-based PDI setup.
- PDI **modules repo** (`modules-pdi-repo`): required when creating modules via PDI repo.
 
with the very basic folder structure and required artifacts. The script enables you to create them individually or combinations of certain repositories.

### Standardised Git Repo Structure - Code Repo

| folder	| description  
|------------------------------------	|---------------------------------  
| `pdi/repo`	| pdi files (ktr, kjb). Also root of file based repo if used.  
| `pdi/sql` | SQL queries
| `pdi/sql/ddl`	| ddl  
| `pentaho-server/metadata`	| pentaho metadata models  
| `pentaho-server/mondrian`	| mondrian cube definitions  
| `pentaho-server/repo`	| contains export from pentaho server repo  
| `pentaho-server/prd`	| perntaho report files  
| `shell-scripts`	| any shell-scripts that don't hold configuration specific instructions  

> **Note**: Data, like lookup tables, must not be stored with the code. For development and unit testing they can be stored in the `config` git repo's `test-data` folder. But in prod it must reside outside any git repo if it is the only source available.

### Standardised Git Repo Structure - Configuration Repo

| folder	| description  
|------------------------------------	|---------------------------------  
| `pdi/.kettle`	| pdi config files  
| `pdi/metadata`	| any metadata files that drive DI processes  
| `pdi/properties`	| properties files source by pdi  
| `pdi/schedules`	| holds crontab instructions, DI server schedules or similar  
| `pdi/shell-scripts`	| shell scripts to execute e.g. PDI jobs  
| `pdi/test-data`	| optional: test data for development or unit testing - specific to environment  
| `pentaho-server/connections`	| pentaho server connections
| `utilities` |  

### How to run the script

The `initialise-repo.sh` script expects following **arguments**:

- action (required)
- project name (not always required)
- environment (not always required)
- PDI file storage (not always required)

> **Important**: The project name must only include letters, no other characters. The same applies to the environment name.

> **Important**: All the repositories have to be located within the same folder. This folder is referred to as `BASE_DIR`.

> **Note**: If any of these repositories already exist within the same folder, they will not be overwritten. The idea is to run the script in a fresh/clean base dir, have the script create the repos and then push them to the central git server.

You can just run the script without arguments and the expected usage pattern will be displayed:

```bash
$ initialise-repo.sh
```

### Example

Creating a new **project** called `myproject` with **common artefacts** for the `dev` **environment** using a PDI file-based **storage approach** 

```bash
$ sh <path-to-script-folder>/initialise-repo.sh -a 1 -g myproject -p mpr -e dev -s file-based
```

This will create a folder called `myproject` in the current directory, which will hold all the other git repositories.

Once this is in place, most settings should be automatically set, however, double check the following files and amend if required:

- `common-config-<env>/pdi/.kettle/repositories.xml` (only when using repo storage mode)
- `common-config-<env>/pdi/shell-scripts/set_env_variables.sh`
- `myproject-config-<env>/pdi/shell-scripts/wrapper.sh`: There are only changes required in the `PROJECT-SPECIFIC CONFIGURATION PROPERTIES` section.
- `myproject-config-<env>/pdi/shell-scripts/run_jb_<project>_master.sh`: adjust path to main PDI job (once it exists).

If you are setting this up on your local workstation, you should be able to start Spoon now and connect to the PDI repository. 

> **Note**: Pay attention to the console output while running the script. There should be a line at the end saying how you can initialise the essential environment variables. You have to run this command before starting Spoon!

As the next step you might want to adjust:

- `common-config-<env>/pdi/.kettle/kettle.properties`
- `common-config-<env>/pdi/.kettle/shared.xml` (only when using file-based storage mode)
- `myproject-config-<env>/pdi/properties/myproject.properties`
- `myproject-config-<env>/pdi/properties/jb_myproject_master.properties`

Don't forget to commit all these changes. You will also have to set the Git remote for these repositories.

### Example: Setting up various environments

Change to the directory where the **Pentaho Standardised Git Repo Setup** repo is located:

We first will create a shell variable called `PSGRS_HOME` to store the location of the **Pentaho Standardised Git Repo Setup** repo:

```bash
$ export PSGRS_HOME=`pwd`
$ echo $PSGRS_HOME
/home/dsteiner/git/pentaho-standardised-git-repo-setup
# your location will be different
```

Let's change the directory now to a convenient location where we can create our new project repos. We will create the dev environment setup and we use a file based setup. Note that we use the action switch `1`, which will create a series of required repos to facilitate the setup:

```bash
# I choose this dir, you might want to choose a different one
$ cd ~/git
$ $PSGRS_HOME/initialise-repo.sh  -a 1 -g myproject -p mpr -e dev -s file-repo
```

At the end of the log output you will find a message like this (path will vary):

```
Before using Spoon, source this file:
source /home/dsteiner/git/myproject/common-config-dev/pdi/shell-scripts/set-env-variables.sh
===============================
```

Execute this command. This will make sure that the essential variables are set for PDI Spoon to pick it up if it is started within the same shell window.

You should have following directories now:

```bash
$ ll myproject/
total 20
drwxrwxr-x. 4 dsteiner dsteiner 4096 Feb  6 23:02 common-config-dev
drwxrwxr-x. 3 dsteiner dsteiner 4096 Feb  6 23:02 common-documentation
drwxrwxr-x. 6 dsteiner dsteiner 4096 Feb  6 23:02 mpr-code
drwxrwxr-x. 6 dsteiner dsteiner 4096 Feb  6 23:02 mpr-config-dev
drwxrwxr-x. 3 dsteiner dsteiner 4096 Feb  6 23:02 mpr-documentatio
```

Each of these folders is a dedicated git repo. It is recommended that you create equivalent repos (so same named repos) on your central **Git Server** (Gitlab, Bitbucket, Github, etc). Usually once you do this, commands will be shown on how to set up those repos locally - usually one of the command sections shown is the one where you can link an **existing** local repo with your online/central one. Use these commands for each of your local repos. So in a nutshell: We are linking our existing local repos with the remote/central repos.

There are a few config settings etc that you can or should adjust at this point, which are mentioned in the previous example section.

Next, within the same terminal window, navigate to the directory where the **PDI client** is installed and start **Spoon**:

```bash
$ sh ./spoon.sh
```

In our case we choose a file repo, so within **Spoon** go to **Tools > Repository > Connect**, choose File Repository and point it to `myproject/mpr-code/pdi/repo`. Any new jobs and transformations should be stored in this repo in the `mpr` folder. You must not change and files within the `modules` folder. Treat it as a read-only folder! Call your main job `jb_mpr_master`.

You can execute your main job via:

```
myproject/mpr-config-dev/pdi/shell-scripts/run_jb_mpr_master.sh
```

Let's simulate another environment called `test` now. For this we have to create an additional set of configs:

- `common-config-test`
- `mpr-config-test`

We use the specific action parameters `common_config` and `project_config` to create these:

```bash
$ $PSGRS_HOME/initialise-repo.sh -a common_config -g myproject -p mpr -e test -s file-repo
$ $PSGRS_HOME/initialise-repo.sh -a project_config -g myproject -p mpr -e test -s file-repo
```

We should see the new repos created now:

```bash
$ ll myproject/
total 28
drwxrwxr-x. 4 dsteiner dsteiner 4096 Feb  6 23:02 common-config-dev
drwxrwxr-x. 4 dsteiner dsteiner 4096 Feb  6 23:22 common-config-test
drwxrwxr-x. 3 dsteiner dsteiner 4096 Feb  6 23:02 common-documentation
drwxrwxr-x. 6 dsteiner dsteiner 4096 Feb  6 23:02 mpr-code
drwxrwxr-x. 6 dsteiner dsteiner 4096 Feb  6 23:02 mpr-config-dev
drwxrwxr-x. 6 dsteiner dsteiner 4096 Feb  6 23:22 mpr-config-test
drwxrwxr-x. 3 dsteiner dsteiner 4096 Feb  6 23:02 mpr-documentation
```

Again, create respective remote/central repos for them and link them up.

Adjust the config files to match the new environment. Among those files will be:

```
myproject/mpr-config-test/pdi/properties/jb_mpr_master.properties
```

You can execute your main job for the new `test` environment via:

```
myproject/mpr-config-test/pdi/shell-scripts/run_jb_mpr_master.sh
```

Note how easy it is to switch the environment: You just pick the respective config folder and everything else is the same!

# Code Repository

## What is NOT Code

- **Configuration**: Goes into dedicated config repo by environment.
- **Documentation**: Goes into dedicated docu repo. 
- **Data**:
	- Lookup Data: E.g. business user provide you with lookup data to enrich operational data. This should be stored separately. 
	- Test Data: Can be stored with your code since it serves the purpose of testing the quality of your code.  
- **Binary files**: Excel, Word, Zip files etc