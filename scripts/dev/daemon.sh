#!/bin/bash
. scripts/dev/_overrides.sh
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
    # AP_API_BASE_URL="http://127.0.0.1/"
fi

for (( i=1; i<100000; i+=1 )); do

    if [ -f /tmp/elex_loader_timeout.sh ]; then
        . /tmp/elex_loader_timeout.sh
    fi

    echo "Timeout:" $ELEX_LOADER_TIMEOUT"s"
    
    SECONDS=0

    TIMESTAMP=$(date +"%s")

    pre
    set_temp_tables

    echo "ELEX LOADER downloading files."

    export ELEX_LOADER_ERROR=false

    local_results & PIDLOCAL=$!
    national_results & PIDNATIONAL=$!
    districts & PIDDISTRICTS=$!
    wait $PIDDISTRICTS
    wait $PIDLOCAL
    wait $PIDNATIONAL

    if [ ! $ELEX_LOADER_ERROR ] ; then
        copy_results
        views

        echo "Results time elapsed:" $SECONDS"s"

        echo "Total time elapsed:" $SECONDS"s"
    fi

    export ERROR=false

    sleep $ELEX_LOADER_TIMEOUT

done