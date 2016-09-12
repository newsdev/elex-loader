#!/bin/bash

. /home/ubuntu/elex-loader/scripts/stg/_delegates.sh
. /home/ubuntu/elex-loader/scripts/stg/_districts.sh
. /home/ubuntu/elex-loader/scripts/stg/_overrides.sh
. /home/ubuntu/elex-loader/scripts/stg/_post.sh
. /home/ubuntu/elex-loader/scripts/stg/_pre.sh
. /home/ubuntu/elex-loader/scripts/stg/_replay_results.sh
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

    # # Commenting out districts for now.
    # if [ "$districts_interval" -eq 0 ]; then 
    #     districts 
    # fi
    views
    post

    sleep $ELEX_LOADER_TIMEOUT

done