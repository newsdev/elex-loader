#!/bin/bash

. scripts/dev/_delegates.sh
. scripts/dev/_districts.sh
. scripts/dev/_overrides.sh
. scripts/dev/_post.sh
. scripts/dev/_pre.sh
. scripts/dev/_results.sh
. scripts/dev/_views.sh

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