#!/bin/bash
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
    ELEX_LOADER_TIMEOUT=5
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

    export ELEX_LOADER_ERROR="0"

    echo $AP_API_BASE_URL"/elections/$RACEDATE?apiKey=$AP_NAT_KEY&format=json&level=ru&national=true&test=true"
    echo $AP_API_BASE_URL"/elections/$RACEDATE?apiKey=$AP_LOC_KEY&format=json&level=ru&national=false&test=true"
    echo $AP_API_BASE_URL"elections/$RACEDATE?apiKey=$AP_NAT_KEY&format=json&level=district&national=true&test=true"

    local_results & PIDLOCAL=$!
    national_results & PIDNATIONAL=$!
    districts & PIDDISTRICTS=$!
    wait $PIDDISTRICTS
    wait $PIDLOCAL
    wait $PIDNATIONAL

    if [ $ELEX_LOADER_ERROR == "0" ] ; then
        copy_results
        views

        echo "Results time elapsed:" $SECONDS"s"
        echo "Total time elapsed (A):" $SECONDS"s"

    fi

    export ERROR="0"

    sleep $ELEX_LOADER_TIMEOUT

done