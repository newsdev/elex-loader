#!/bin/bash

. scripts/dev/_districts.sh
. scripts/dev/_post.sh
. scripts/dev/_pre.sh
. scripts/dev/_results.sh
. scripts/dev/_views.sh

if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

if [[ -z $AP_API_BASE_URL ]] ; then
    AP_API_BASE_URL="http://api.ap.org/v2/"
fi

pre
set_db_tables

echo $AP_API_BASE_URL

local_results & PIDLOCAL=$!
national_results & PIDNATIONAL=$!
wait $PIDLOCAL
wait $PIDNATIONAL

views
post