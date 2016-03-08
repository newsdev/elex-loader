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

let wait_time=30

for (( i=1; i<100000; i+=1 )); do

    let delegates_interval=i%4
    let districts_interval=i%3

    pre
    if [ "$delegates_interval" -eq 0 ]; then 
        delegates
    fi
    if [ "$districts_interval" -eq 0 ]; then
        districts 
    fi
    results
    views
    cd /home/ubuntu/election-2016/LATEST/ && npm run post-update "$RACEDATE"
    post

    sleep $wait_time

done