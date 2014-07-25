#!/bin/sh

# $1, first input, describe this time commit
# determine whether $1 is empty or not
# if $1 is empty, then show the usage of this update.sh 
# else if $1 equal to sth, do the git update 
if [ -z "$1" ]; then
	echo *************usage ************
	echo usage: sh update.sh description
	echo usage: describe what is meaning of this commit.
	echo '$1' = $1
else 
# before push, check pull first
	git pull origin master
# then do push
	git add .
	git commit -m "$1"
	git push origin master
fi

## test edit
