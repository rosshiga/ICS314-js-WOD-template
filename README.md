# ICS314-js-WOD-template
This script creates a new github repository with an IntelliJ IDEA project set up for ICS 314 JavaScript WODs.

## Requirements
This should run on any Linux machine that has curl installed. This should also run on OS X if you install curl, but has not been tested. To install curl on Ubuntu: `sudo apt-get install curl`

## Installation
* Clone this repository (`git clone git@github.com:AustinHaigh/ICS314-js-WOD-template.git`)
* Create a [Personal Access Token](https://github.com/settings/tokens)
* Add your username and token to the .create_repo.env file (`nano .create_repo.env`)

## Usage
* Open a terminal
* Navigate to the ICS314-js-WOD-template folder
* Run `./create_repo.sh name_of_WOD`
* Your project will open in IntelliJ IDEA. Do the WOD.
* When you close IDEA your project will automatically be committed and pushed to a private GitHub repository, and the grader configured in the .create_repo.env file will be given access.
