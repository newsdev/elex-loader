#!/bin/bash

# Get script location, so scripts work from this repo
# and when installed into Node modules
SCRIPT_DIR=$(dirname $BASH_SOURCE)

. $SCRIPT_DIR'/_post.sh'
. $SCRIPT_DIR'/_pre.sh'
. $SCRIPT_DIR'/_results.sh'
# . $SCRIPT_DIR'/_views.sh'

if [[ ! -z $1 ]] ; then
    RACEDATE=$1
fi

if [[ -z $AP_API_BASE_URL ]] ; then
    AP_API_BASE_URL="http://api.ap.org/v2/"
fi

TIMESTAMP=$(date +"%s")

pre
#set_temp_tables

echo "0" > elex_error.txt

echo $AP_API_BASE_URL"/elections/$RACEDATE?apiKey=$AP_NAT_KEY&format=json&level=ru"

results & PIDRESULTS=$!
wait $PIDRESULTS

while read p; do
    if [ $p == "0" ] ; then
        #copy_results
        #views

        echo "Results time elapsed:" $SECONDS"s"

        echo "Total time elapsed (A):" $SECONDS"s"
    fi
done <elex_error.txt

echo "0" > elex_error.txt

