
# Required parameters
# Location of repository file
PDI_REPOSITORY_FILE=
PROJECT_NAME=
BASE_DIR=

# if repositories.xml exists in common config folder already:
#   check if repo is already defined
#   if not add it
if [ -d "${PDI_REPOSITORY_FILE}" ]; then
# sublime has some syntax highlighting issues if EOL is indented, so not indenting here
REPO_CHECK=$(grep "<name>${PROJECT_NAME}</name>"  ${PDI_REPOSITORY_FILE})
if [REPO_CHECK = "" ]; then
  # remove existing repositories end tag
  perl -0777 -pe 's@</repositories>@@igs' -i ${PDI_REPOSITORY_FILE}
  # add new repository details and new repositories end tag
  cat > ${PDI_REPOSITORY_FILE} <<EOL
  <repository>    
    <id>KettleFileRepository</id>
    <name>${PROJECT_NAME}</name>
    <description>${PROJECT_NAME}</description>
    <is_default>false</is_default>
    <base_directory>${BASE_DIR}</base_directory>
    <read_only>N</read_only>
    <hides_hidden_files>N</hides_hidden_files>
  </repository>
</repositories>
EOL
else
# if not:
#   add the whole file
cat > ${PDI_REPOSITORY_FILE} <<EOL
<?xml version="1.0" encoding="UTF-8"?>
<repositories>
  <repository>    
    <id>KettleFileRepository</id>
    <name>${PROJECT_NAME}</name>
    <description>${PROJECT_NAME}</description>
    <is_default>false</is_default>
    <base_directory>${BASE_DIR}</base_directory>
    <read_only>N</read_only>
    <hides_hidden_files>N</hides_hidden_files>
  </repository>
</repositories>
EOL
fi