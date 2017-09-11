#!/bin/bash
cd ${PENTAHO_SERVER_HOME}
./import-export.sh \
--export \
--url=http://localhost:8080/pentaho \
--username=admin \
--password=password \
--file-path=c:/temp/export.zip \
--charset=UTF-8 \
--path=/public \
--withManifest=true \
--logfile=c:/temp/logfile.log
