#!/bin/bash

. node_modules/elex-loader/scripts/dev-node/_delegates.sh
. node_modules/elex-loader/scripts/dev-node/_districts.sh
. node_modules/elex-loader/scripts/dev-node/_overrides.sh
. node_modules/elex-loader/scripts/dev-node/_post.sh
. node_modules/elex-loader/scripts/dev-node/_pre.sh
. node_modules/elex-loader/scripts/dev-node/_results.sh
. node_modules/elex-loader/scripts/dev-node/_views.sh

let wait_time=30

if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

pre

for (( iteration=1; iteration<100000; iteration+=1 )); do
    let delgates_interval=iteration%4
    let districts_interval=iteration%3

    if [ "$delgates_interval" -eq 0 ]; then delegates fi
    if [ "$districts_interval" -eq 0 ]; then districts fi
    results
    post

    sleep $wait_time
done