#!/bin/bash

. node_modules/elex-loader/scripts/dev-node/_delegates.sh
. node_modules/elex-loader/scripts/dev-node/_districts.sh
. node_modules/elex-loader/scripts/dev-node/_overrides.sh
. node_modules/elex-loader/scripts/dev-node/_post.sh
. node_modules/elex-loader/scripts/dev-node/_pre.sh
. node_modules/elex-loader/scripts/dev-node/_results.sh
. node_modules/elex-loader/scripts/dev-node/_views.sh

if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

let wait_time=30

for (( i=1; i<100000; i+=1 )); do

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
    post

    sleep $wait_time

done