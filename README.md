# ICS314-js-WOD-template
This script creates a new github repository with an IntelliJ IDEA project set up for ICS 314 JavaScript WODs. The project is configured according to the [ICS314 Javascript coding standards](http://courses.ics.hawaii.edu/ics314f18/morea/coding-standards/reading-javascript-coding-standards.html).

## Requirements
This should run on any Linux machine that has curl and sed installed. This should also run on OS X if you install curl and sed (assuming they're not installed by default), but has not been tested. It will probably also work on Windows if you use cygwin to install curl and sed. To install curl on Ubuntu (sed is included in Ubuntu by default): `sudo apt-get install curl`

## Installation
* Clone this repository (`git clone git@github.com:AustinHaigh/ICS314-js-WOD-template.git`)
* (Optional) Create a [Personal Access Token](https://github.com/settings/tokens) (you can also use your password, if you didn't enable GitHub 2FA)
* (Optional) Edit .create_repo.env to configure default options (otherwise you'll need to use command line arguments)

## Usage
* Open a terminal
* Navigate to the ICS314-js-WOD-template folder
* Run `./create_repo.sh -n name_of_WOD`
* Your project will open in IntelliJ IDEA. Do the WOD.
* If IDEA was already open before you ran the script, switch to the terminal and press enter to push your WOD to GitHub. If IDEA was not open, your project will be pushed to GitHub automatically when you close IDEA.

```Usage: create_repo.sh [-n <repo name>] [-u <username> (-p <password> | -o <oath token>)] [-g <grader>] [-c] [-j] [-s]```

|Command line argument| .env file name | Description|
|---|---|---|
| -n | REPONAME | repository name|
| -u | USERNAME | GitHub username|
| -p | PASSWORD | GitHub password|
| -o | OAUTH_TOKEN | GitHub Oauth token|
| -g | GRADER | GitHub username to give access to the repo|
| -c | CSS | Add a 'style.css' file and a <link> tag in index.html|
| -j | JS | Add a '<reponame>.js' file and a <script> tag in index.html|
| -s | SEMANTIC | Add the Semantic and JQuery to your index.html|
| -_ | UNDERSCORE | Add Underscore.js to your index.html|

