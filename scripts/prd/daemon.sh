#!/bin/bash

. /home/ubuntu/elex-loader/scripts/prd/_delegates.sh
. /home/ubuntu/elex-loader/scripts/prd/_districts.sh
. /home/ubuntu/elex-loader/scripts/prd/_node_post_update.sh
. /home/ubuntu/elex-loader/scripts/prd/_overrides.sh
. /home/ubuntu/elex-loader/scripts/prd/_post.sh
. /home/ubuntu/elex-loader/scripts/prd/_pre.sh
. /home/ubuntu/elex-loader/scripts/prd/_results.sh
. /home/ubuntu/elex-loader/scripts/prd/_views.sh

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