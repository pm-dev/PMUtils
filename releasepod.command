#!/bin/sh

#  releasepod.command
#  
#
#  Created by Peter Meyers on 3/25/14.
#


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR/Example
pod update

cd $DIR

VERSION=$(rake localversion)
REPO_NAME=${PWD##*/}
git add -A
git commit -m "Release $VERSION"
git tag -a $VERSION -m "Release $VERSION"
git push origin master --tags
pod repo push PMSpecs $REPO_NAME.podspec 
