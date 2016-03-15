#!/bin/bash

. scripts/prd/_admin.sh
. scripts/prd/_delegates.sh
. scripts/prd/_districts.sh
. scripts/prd/_init.sh
. scripts/prd/_overrides.sh
. scripts/prd/_post.sh
. scripts/prd/_pre.sh
. scripts/prd/_views.sh

if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

if [[ -z $OVERRIDE_DIR ]] ; then
    OVERRIDE_DIR='/home/ubuntu/elex-loader/overrides'
fi

pre
overrides
init
#districts
delegates
views
admin
post