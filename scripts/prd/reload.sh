#!/bin/bash

. scripts/stg/_delegates.sh
. scripts/stg/_districts.sh
. scripts/stg/_init.sh
. scripts/stg/_overrides.sh
. scripts/stg/_post.sh
. scripts/stg/_pre.sh
. scripts/stg/_views.sh

if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

if [[ -z $OVERRIDE_DIR ]] ; then
    OVERRIDE_DIR='/home/ubuntu/elex-loader/overrides'
fi

pre
overrides
init
districts
delegates
views
post