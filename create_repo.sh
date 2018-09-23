#!/bin/bash

source .create_repo.env

if [[ $# -ne 1 ]]
then
	echo Usage: $0 [repo name]
	exit 1
fi


RESPONSE=$(curl -sS -H "Authorization: token $OAUTH_TOKEN" https://api.github.com/user/repos -d '{"name":"'$1'", "private":"true", "auto_init":"true"}')
if [[ $(grep "Bad credentials" <<< "$RESPONSE") ]]
then
	echo "Invalid password"
	exit 1
fi
if [[ $(grep "errors" <<< "$RESPONSE") ]]
then 
	grep message <<< "$RESPONSE" | sed -r 's/.*message": "([a-zA-Z \.]+).*/\1/'
	exit 1
fi

#curl -sS -H "Authorization: token $OAUTH_TOKEN" https://api.github.com/repos/$USERNAME/$1/collaborators/$GRADER -d '{"permission":"pull"}' -X PUT

shopt -s dotglob

cp -rap js_template/. $1 &&
rename js_template $1 $1/* &&
find $1 -type f -exec sed -r -i "s/js_template/$1/" {} + &&
git clone git@github.com:$USERNAME/$1.git tmp &&
mv tmp/* $1 &&
rm -rf tmp &&

cd $1 

PROC=$(ps aux |grep idea | wc -l)
idea $1.js 2> /dev/null
if [[ $PROC -gt 1 ]]
then
		echo Press enter to commit and push to GitHub
		read
fi

git add . &&
git commit -m "WOD done" &&
git push

