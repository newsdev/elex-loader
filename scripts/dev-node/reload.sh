#!/bin/bash

. node_modules/elex-loader/scripts/dev-node/_delegates.sh
. node_modules/elex-loader/scripts/dev-node/_districts.sh
. node_modules/elex-loader/scripts/dev-node/_init.sh
. node_modules/elex-loader/scripts/dev-node/_overrides.sh
. node_modules/elex-loader/scripts/dev-node/_post.sh
. node_modules/elex-loader/scripts/dev-node/_pre.sh
. node_modules/elex-loader/scripts/dev-node/_views.sh

if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

if [[ -z $OVERRIDE_DIR ]] ; then
    OVERRIDE_DIR='overrides'
fi

pre
overrides
init
#districts
delegates
views
post