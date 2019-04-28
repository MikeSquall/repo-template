#!/bin/bash
set -e

#############
# Variables #
#############

USAGE='''
Usage: init_repo <REPO_NAME> <PACKAGE_MANAGER>

  PACKAGE_MANAGER   yarn or npm
'''

PACKAGE_LIST=(
  "codacy-coverage"
  "husky"
  "prettier"
  "pretty-quick"
  "typescript"
  "ts-lint"
  "parcel"
  "rimraf"
  "remark-cli"
  "remark-lint"
  "remark-preset-lint-recommended"
  "jest"
  "ts-jest"
  "@types/jest"
)

HUSKY_CONF='
{
  "husky": {
    "hooks": {
      "pre-commit": "pretty-quick --staged"
    }
  }
}
'

#############
#   Logic   #
#############

# Check if we have the 2 required args
[[ $# -ne 2 ]] && echo "$USAGE" && exit 1

REPO_NAME=$1
PACKAGE_MANAGER=$2

# Check if we can create the new repo
[[ -d "$REPO_NAME" ]] && echo "$REPO_NAME already exists here. Change name or current path." && exit 2

# Check if the $PACKAGE_MANAGER is valid
[[ "$PACKAGE_MANAGER" -ne "yarn" ]] && [[ "$PACKAGE_MANAGER" -ne "npm" ]] && echo "$USAGE" && exit 3

mkdir $REPO_NAME
cd $REPO_NAME
pwd
$PACKAGE_MANAGER init

jq --argjson husky "$HUSKY_CONF" '. += $husky' package.json > tmp.json
mv tmp.json package.json

[[ "$PACKAGE_MANAGER" -eq "yarn" ]] && yarn add -D ${PACKAGE_LIST[*]}
[[ "$PACKAGE_MANAGER" -eq "npm" ]] && npm install ${PACKAGE_LIST[*]} --save-dev
