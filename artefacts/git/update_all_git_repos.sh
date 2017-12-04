#!/bin/bash

# Kindly provided by Luis Silva

# Script to update all of the 
# git repositories under this folder.

cd $PWD
pad=$(printf '%0.1s' " "{1..150})
padlength=80
SUCCESS="SUCCESS!"
FAILURE="FAILURE!"

# The following is for the correct padding of output messages.
function success()
{
      local folder=$1
      printf '%*.*s' 0 $((padlength - ${#folder} - 9 )) "$pad"
      printf '\e[32m%s\e[39m\n' $SUCCESS
}

function failure()
{
      local folder=$1
      printf '%*.*s' 0 $((padlength - ${#folder} - 9 )) "$pad"
      printf '\e[31m%s\e[39m\n' $FAILURE
}

for sandbox in `find . -type d -iname .git`
do 
   (
      folder=`readlink -f $sandbox/..`
      printf '%s' "Updating $folder..."
      cd $folder && git pull > /dev/null 2>&1 && success $folder || failure $folder 
   )
done

