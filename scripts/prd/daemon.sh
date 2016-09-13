#!/bin/bash

. /home/ubuntu/elex-loader/scripts/prd/_delegates.sh
. /home/ubuntu/elex-loader/scripts/prd/_districts.sh
. /home/ubuntu/elex-loader/scripts/prd/_overrides.sh
. /home/ubuntu/elex-loader/scripts/prd/_post.sh
. /home/ubuntu/elex-loader/scripts/prd/_pre.sh
. /home/ubuntu/elex-loader/scripts/prd/_results.sh
. /home/ubuntu/elex-loader/scripts/prd/_views.sh

if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

if [ -f /tmp/elex_loader_timeout.sh ]; then
    . /tmp/elex_loader_timeout.sh
fi

if [[ -z $ELEX_LOADER_TIMEOUT ]] ; then
    ELEX_LOADER_TIMEOUT=30
fi

for (( i=1; i<100000; i+=1 )); do

    if [ -f /tmp/elex_loader_timeout.sh ]; then
        . /tmp/elex_loader_timeout.sh
    fi

    echo "Timeout:" $ELEX_LOADER_TIMEOUT"s"

    let districts_interval=i%3

    pre
    set_db_tables

    # Run local / national results in parallel.
    # Will block the rest of the scripts until it's done.
    local_results & PIDLOCAL=$!
    national_results & PIDNATIONAL=$!
    wait $PIDLOCAL
    wait $PIDNATIONAL

    views
    cd /home/ubuntu/election-2016/LATEST/ && npm run post-update "$RACEDATE"
    post

    sleep $ELEX_LOADER_TIMEOUT

done