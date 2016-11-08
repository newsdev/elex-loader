#!/bin/bash
. /home/ubuntu/elex-loader/scripts/stg/_post.sh
. /home/ubuntu/elex-loader/scripts/stg/_pre.sh
. /home/ubuntu/elex-loader/scripts/stg/_results.sh
. /home/ubuntu/elex-loader/scripts/stg/_views.sh

if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

if [[ -z $AP_API_BASE_URL ]] ; then
    AP_API_BASE_URL="http://api.ap.org/v2/"
fi

TIMESTAMP=$(date +"%s")

pre
set_temp_tables

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
        views

        echo "Results time elapsed:" $SECONDS"s"

        echo "Total time elapsed (A):" $SECONDS"s"
    fi
done </tmp/elex_error.txt

echo "0" > /tmp/elex_error.txt