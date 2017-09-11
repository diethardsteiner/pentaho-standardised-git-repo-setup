#!/bin/bash
cd ${PENTAHO_SERVER_HOME}
./import-export.sh \
--import \
--url=http://localhost:8080/pentaho \
--username=admin \
--password=password \
--charset=UTF-8 \
--path=/public \
--file-path=c:/temp/steel-wheels \
--logfile=c:/temp/logfile.log \
--permission=true \
--overwrite=true
