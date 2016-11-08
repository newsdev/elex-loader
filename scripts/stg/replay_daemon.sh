#!/bin/bash
. /home/ubuntu/elex-loader/scripts/stg/_post.sh
. /home/ubuntu/elex-loader/scripts/stg/_pre.sh
. /home/ubuntu/elex-loader/scripts/stg/_results.sh
. /home/ubuntu/elex-loader/scripts/stg/_views.sh
. /etc/environment

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
    AP_API_BASE_URL="http://int-elex-stg-east.newsdev.net/elections/2016/deja-vu/"
fi

for (( i=1; i<100000; i+=1 )); do

    cd /home/ubuntu/elex-loader/

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

    while read p; do
        if [ $p == "0" ] ; then
            copy_results
            views

            echo "Results time elapsed:" $SECONDS"s"
            echo $(readlink -f /home/ubuntu/election-2016/LATEST/)
            cd /home/ubuntu/election-2016/LATEST/ && npm run post-update "$RACEDATE"

            echo "Total time elapsed (A):" $SECONDS"s"
        fi
    done </tmp/elex_error.txt

    echo "0" > /tmp/elex_error.txt

    sleep $ELEX_LOADER_TIMEOUT

done
