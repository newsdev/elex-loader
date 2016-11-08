#!/bin/bash
. scripts/dev/_overrides.sh
. scripts/dev/_pre.sh
. scripts/dev/_results.sh
. scripts/dev/_views.sh

if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

if [[ -z $OVERRIDE_DIR ]] ; then
    OVERRIDE_DIR='overrides'
fi

if [[ -z $AP_API_BASE_URL ]] ; then
    AP_API_BASE_URL="http://api.ap.org/v2/"
fi

TIMESTAMP=$(date +"%s")

pre
set_temp_tables
set_live_tables

echo "0" > /tmp/elex_error.txt

local_results & PIDLOCAL=$!
national_results & PIDNATIONAL=$!
districts & PIDDISTRICTS=$!
wait $PIDDISTRICTS
wait $PIDLOCAL
wait $PIDNATIONAL

while read p; do
    if [ $p == "0" ] ; then
        copy_results
        overrides
        views

        echo "Results time elapsed:" $SECONDS"s"
        echo "Total time elapsed (A):" $SECONDS"s"
    fi
done </tmp/elex_error.txt

echo "0" > /tmp/elex_error.txt