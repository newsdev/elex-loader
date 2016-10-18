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

    if [ -f /tmp/elex_loader_timeout.sh ]; then
        . /tmp/elex_loader_timeout.sh
    fi

    echo "Timeout:" $ELEX_LOADER_TIMEOUT"s"

    TIMESTAMP=$(date +"%s")

    cd /home/ubuntu/elex-loader/

    pre
    set_db_tables

    local_results & PIDLOCAL=$!
    national_results & PIDNATIONAL=$!
    wait $PIDLOCAL
    wait $PIDNATIONAL

    views
    post
    cd /home/ubuntu/election-2016/LATEST/ && npm run post-update "$RACEDATE"

    sleep $ELEX_LOADER_TIMEOUT

done