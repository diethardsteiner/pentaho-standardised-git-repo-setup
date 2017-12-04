#!/bin/bash

# Kindly provided by Luis Silva

# Script to list the latest tags for all
# git repositories under this folder.

cd $PWD

# Header
printf "%-30s|%-15s %-6s|%-11s|%-15s|%-11s\n" "REPO" "latest" "+extra" "date" "deployed" "date"
printf "%-30s|%-15s-%-6s|%-11s|%-15s|%-11s\n" "------------------------------" "---------------" "------" "-----------" "---------------" "-----------"

# loop over all of the sandboxes below the current folder except those that 
# have data in the name.
for sandbox in `find . -type d -iname .git|grep -v data|sort`
do 
   (
      # Get the simplified path of the repo
      folder=`readlink -f $sandbox/..`
      cd $folder

      # Extract deployed tag
      deployed=`git tag --sort=committerdate -l *-prod|grep -v pre-prod|tail -n1`
      deployed_date=""
      test -n "$deployed" && deployed_date=`git show -s --pretty=%ci $deployed|cut -c -10`
      
      # Extract latest tag
      latest=`git tag --sort=committerdate -l |tail -n1`
      latest_date=""
      test -n "$latest" && latest_date=`git show -s --pretty=%ci $latest|cut -c -10`

      # Check for extra commits since the latest tag.
      extra_commits=""
      # There may not be a lates tag so account for that.
      test -n "$latest" && extra_commits="+`git rev-list --count ^$latest HEAD`"

      # for each project, print all we have on it.
      printf "%-30s|%-15s %-6s|%-11s|%-15s|%-11s\n" "`basename $folder`" "$latest" "$extra_commits" "$latest_date" "$deployed" "$deployed_date"
   )
done

