#!/bin/bash

. scripts/dev/_districts.sh
. scripts/dev/_post.sh
. scripts/dev/_pre.sh
. scripts/dev/_results.sh
. scripts/dev/_views.sh

if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

pre
set_db_tables

local_results & PIDLOCAL=$!
national_results & PIDNATIONAL=$!
wait $PIDLOCAL
wait $PIDNATIONAL

views
post