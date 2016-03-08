#!/bin/bash

. node_modules/elex-loader/scripts/dev-node/_delegates.sh
. node_modules/elex-loader/scripts/dev-node/_post.sh
. node_modules/elex-loader/scripts/dev-node/_pre.sh
. node_modules/elex-loader/scripts/dev-node/_views.sh

if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

pre
delegates
views
post