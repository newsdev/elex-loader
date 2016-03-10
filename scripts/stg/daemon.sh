#!/bin/bash

. /home/ubuntu/elex-loader/scripts/stg/_delegates.sh
. /home/ubuntu/elex-loader/scripts/stg/_districts.sh
. /home/ubuntu/elex-loader/scripts/stg/_node_post_update.sh
. /home/ubuntu/elex-loader/scripts/stg/_overrides.sh
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

for (( i=1; i<100000; i+=1 )); do

    if [ -f /tmp/elex_loader_timeout.sh ]; then
        . /tmp/elex_loader_timeout.sh
    fi

    echo "Timeout:" $ELEX_LOADER_TIMEOUT"s"

    let delegates_interval=i%4
    let districts_interval=i%3

    pre
    results
    if [ "$delegates_interval" -eq 0 ]; then 
        delegates
    fi
    if [ "$districts_interval" -eq 0 ]; then 
        districts 
    fi
    views
    cd /home/ubuntu/election-2016/LATEST/ && npm run post-update "$RACEDATE"
    post

    sleep $ELEX_LOADER_TIMEOUT

done