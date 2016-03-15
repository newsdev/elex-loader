#!/bin/bash

. scripts/dev/_delegates.sh
. scripts/dev/_districts.sh
. scripts/dev/_init.sh
. scripts/dev/_overrides.sh
. scripts/dev/_post.sh
. scripts/dev/_pre.sh
. scripts/dev/_views.sh

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