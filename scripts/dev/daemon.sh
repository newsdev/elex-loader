#!/bin/bash
. scripts/dev/_districts.sh
. scripts/dev/_overrides.sh
. scripts/dev/_post.sh
. scripts/dev/_pre.sh
. scripts/dev/_results.sh
. scripts/dev/_views.sh

if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

if [ -f /tmp/elex_loader_timeout.sh ]; then
    . /tmp/elex_loader_timeout.sh
fi

if [[ -z $ELEX_LOADER_TIMEOUT ]] ; then
    ELEX_LOADER_TIMEOUT=30
fi

if [[ -z $AP_API_BASE_URL ]] ; then
    AP_API_BASE_URL="http://api.ap.org/v2/"
fi

for (( i=1; i<100000; i+=1 )); do

    if [ -f /tmp/elex_loader_timeout.sh ]; then
        . /tmp/elex_loader_timeout.sh
    fi

    echo "Timeout:" $ELEX_LOADER_TIMEOUT"s"

    let districts_interval=i%3

    pre
    set_temp_tables

    local_results & PIDLOCAL=$!
    national_results & PIDNATIONAL=$!
    districts & PIDDISTRICTS=$!
    wait $PIDDISTRICTS
    wait $PIDLOCAL
    wait $PIDNATIONAL

    # copy_results
    truncate_copy
    # truncate_insert
    views
    post

    sleep $ELEX_LOADER_TIMEOUT

done