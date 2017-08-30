
function add_pdi_repository {
  
while getopts ":r:p:b:" opt; do
  case $opt in
    r) DI_REPOSITORY_FILE="$OPTARG"
        echo "Submitted action value: ${DI_REPOSITORY_FILE}"
    ;;
    p) PROJECT_NAME="$OPTARG"
        echo "Submitted project name value: ${PROJECT_NAME}"
    ;;
    b) PDI_REPO_BASE_DIR="$OPTARG"
        echo "Submitted environment value: ${PDI_ENV}" 
    ;;
    \?) 
      echo "Invalid option -$OPTARG" >&2
      exit 1
    ;;
  esac
done

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
    <base_directory>${PDI_REPO_BASE_DIR}</base_directory>
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
    <base_directory>${PDI_REPO_BASE_DIR}</base_directory>
    <read_only>N</read_only>
    <hides_hidden_files>N</hides_hidden_files>
  </repository>
</repositories>
EOL
fi
fi
}
