#!/bin/sh

#  updatepod.command
#  
#
#  Created by Peter Meyers on 3/25/14.
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
pod update
