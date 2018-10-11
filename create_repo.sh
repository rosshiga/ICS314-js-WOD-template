#!/bin/bash

shopt -s dotglob
MYDIR="$(dirname "$(realpath "$0")")"
source $MYDIR/.create_repo.env

function mkrepo {
	if [[ "$PASSWORD" ]]; then
		AUTH="$USERNAME:$PASSWORD"
		METHOD="--user"
	elif [[ "$OAUTH_TOKEN" ]]; then
		METHOD="-H"
		AUTH="Authorization: token $OAUTH_TOKEN"
	else
		METHOD="--user"
		AUTH="$USERNAME"
	fi

	RESPONSE=$(curl -sS $METHOD "$AUTH" https://api.github.com/user/repos -d '{"name":"'$REPONAME'", "private":"true", "auto_init":"true"}')
	if [[ $(grep "Bad credentials" <<< "$RESPONSE") ]]
	then
		echo "Invalid password or token"
		exit 1
	fi
	if [[ $(grep "errors" <<< "$RESPONSE") ]]
	then 
		grep message <<< "$RESPONSE" | sed -r 's/.*message": "([a-zA-Z \.]+).*/\1/'
		exit 1
	fi

	if [ ! -z "$GRADER" ]; then
		curl -sS $METHOD "$AUTH" https://api.github.com/repos/$USERNAME/$REPONAME/collaborators/$GRADER -d '{"permission":"pull"}' -X PUT
	fi

	if [ "$REACT" == "true" ]; then
		mkdir $REPONAME
		cp $MYDIR/wod_template/.gitignore $REPONAME &&
		cp -r $MYDIR/wod_template/{.idea,*.iml} $REPONAME &&
		cp -rap $MYDIR/react_template $REPONAME/my-app &&
		rm $REPONAME/my-app/src/* &&
		touch $REPONAME/my-app/src/index.css &&
		cat > $REPONAME/my-app/src/index.js << EOF
import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
EOF

		INDEX="$REPONAME/my-app/src/index.js"

	else
		cp -rap $MYDIR/wod_template/. $REPONAME &&
		rename wod_template $REPONAME $REPONAME/* &&
		find $REPONAME -type f -exec sed -r -i "s/wod_template/$REPONAME/" {} + 
		INDEX="$REPONAME/index.html"
	fi

	[ "$?" == 0 ] && git clone git@github.com:$USERNAME/$REPONAME.git tmp &&
	mv tmp/* $REPONAME &&
	rm -rf tmp &&
	if [ "$JS" == "true" ]; then 
		touch $REPONAME/$REPONAME.js
		sed -i '/<head>/a <script type="text/javascript" src="'"$REPONAME.js"'"></script>' $REPONAME/index.html
	fi
	if [ "$CSS" == "true" ]; then
		touch $REPONAME/style.css
		sed -i '/<head>/a <link rel="stylesheet" href="style.css">' $REPONAME/index.html
	fi
	if [ "$SEMANTIC" == "true" ]; then
		sed -i '/<head>/a <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.3.3/semantic.min.css">\n<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>\n<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.3.3/semantic.min.js"></script>' $REPONAME/index.html
	fi
	if [ "$UNDERSCORE" == "true" ]; then
		sed -i '/<head>/a <script src="//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min.js"></script>' $REPONAME/index.html
	fi
}

function start_idea {
	PROC=$(ps aux |grep idea | wc -l)
	echo
	echo
	echo Opening project in IntelliJ IDEA...
	idea $INDEX 2> /dev/null
	if [[ $PROC -gt 1 ]]
	then
		echo Press enter to commit and push to GitHub
		read
	fi
}

function git_push {
	git add . &&
	git commit -m "$COMMIT_MSG" &&
	git push
}

function usage { 
	echo "Usage: $0 [-n <repo name>] [-u <username> (-p <password> | -o <oath token>)] [-g <grader>] [-m <commit msg>] [-c] [-j] [-s] [-r] [-z]"
} 

while getopts "n:u:p:o:g:m:cjs_rz" o; do
	case $o in 
		n)
			REPONAME="$OPTARG"
			;;
		u)
			USERNAME="$OPTARG"
			;;
		p)
			PASSWORD="$OPTARG"
			;;
		o)
			OAUTH_TOKEN="$OPTARG"
			;;
		g)
			GRADER="$OPTARG"
			;;
		c)
			CSS="true"
			;;
		j)
			JS="true"
			;;
		s)
			SEMANTIC="true"
			;;
		_)
			UNDERSCORE="true"
			;;
		m)
			COMMIT_MSG="$OPTARG"
			;;
		z)
			NO_COMMIT="true"
			;;
		r)
			REACT="true"
			;;
		*)
			usage
			exit 1
			;;
	esac
done
shift $((OPTIND-1))

if [ -z "$REPONAME" ] || [ -z "$USERNAME" ]; then
	usage
	exit 1
fi

if [[ "$REACT" && ( "$CSS" == "true" || "$JS" == "true" || "$SEMANTIC" == "true" || "$UNDERSCORE" == "true" ) ]]; then
	echo "Using React with CSS (-c), JS (-j), Semantic (-s), or Underscore (-_) is not supported at this time"
	exit 1
fi

if [[ "$PASSWORD" && "$OAUTH_TOKEN" ]]; then
	echo WARNING: both password and oauth token have been given, using password.
fi

mkrepo $REPONAME &&
cd $REPONAME &&
start_idea $REPONAME
[[ "$NO_COMMIT" != "true" ]] && git_push
echo 
echo 
echo ====================
echo GitHub repo created
echo URL: https://github.com/$USERNAME/$REPONAME
echo
