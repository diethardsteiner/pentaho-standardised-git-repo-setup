# pentaho-standardised-git-repo-setup


## Initial Setup

The `utilities` (pentaho-standardised-git-repo-setup) git repo is provided as a template. You will have to change a few configuration details to make it fit within your organisation. Once you have made these changes, you have to make it available via a Git Server/Web Frontend like **Github**, **GitLab**, **Bitbucket** or similar. From there, anyone who wants to create a new Git project within your organisation, can clone this pre-configured `utilities` repo and run the `initialise-repo.sh` script located within it, which will set up the basic git folder structure.

You have to change the following in the utilities folder:

- `shell-scripts/initialise-repo.sh`: There is only one parameter to define called `MODULES_GIT_REPO_URL`, which is the **SSH** or **HTTPS** URL to clone the **modules repo**. 

> **Note**: If this modules repo is not present yet, use the `shell-scripts/initialise-repo.sh` to create it and push it to your Git Server (GitHub, etc). Then adjust the configuration.


## Initialise Project Structure

Clone the `utilities` repo. Inside the `shell-script` folder, you can find a script called `initialise-repo.sh`, which can create:

- project-specific **config repo** for a given environment (`<proj>-conf-<env>`)
- common **config repo** for a given environment (`common-conf-<env>`)
- project **code repo** (`<proj>-code`)
- common **docu repo** (`common-documentation`)
- project **docu repo** (`<proj>-documentation`)
- PDI **modules** (`modules`): for reusable code/patterns. Holds plain modules only, so it can be use either in file-based or repo-based PDI setup.
- PDI **modules repo** (modules-pdi-repo): required when creating modules via PDI repo.
 
with the very basic folder structure and required artifacts. The script enables you to create them individually or combinations of certain repositories.

The `initialise-repo.sh` script expects following **arguments**:

- action (required)
- project name (not always required)
- environment (not always required)
- PDI file storage (not always required)

> **Important**: The project name must only include letters, no other characters. The same applies to the environment name.

> **Important**: All the repositories have to be located within the same folder. This folder is referred to as `BASE_DIR`.

> **Note**: If any of these repositories already exist within the same folder, they will not be overwritten.

## Example

Creating a new **project** called `myproject` with **common artefacts** for the `dev` **environment** using a PDI file-based **storage approach** 

```bash
$ sh ./utilities/shell-scripts/initialise-repo.sh -a 1 -p myproject -e dev -s files
```

Once this is in place, you have to change the following:

- `common-config-<env>/.kettle/repositories.xml` (only when using repo storage mode): Set the path to the PDI repository of your project (located in `myproject/etl`) as well as provide a name and description for the PDI repository.
- `common-config-<env>/shell-scripts/set_env_variables.sh`
- `myproject-config-<env>/shell-scripts/wrapper.sh`: There are only changes required in the `PROJECT-SPECIFIC CONFIGURATION PROPERTIES` section.

If you are setting this up on your local workstation, you should be able to start Spoon now and connect to the PDI repository. 

As the next step you might want to adjust:

- `common-config-<env>/.kettle/kettle.properties`
- `common-config-<env>/.kettle/shared.xml` (only when using file-based storage mode)
- `myproject-config-<env>/properties/myproject.properties`
- `myproject-config-<env>/properties/jb_myproject_master.properties`

Don't forget to commit all these changes. You will also have to set the Git remote for these repositories.