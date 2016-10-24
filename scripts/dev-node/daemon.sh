#!/bin/bash

# Get script location, so scripts work from this repo
# and when installed into Node modules
SCRIPT_DIR=$(dirname $BASH_SOURCE)

. $SCRIPT_DIR'/_districts.sh'
. $SCRIPT_DIR'/_overrides.sh'
. $SCRIPT_DIR'/_post.sh'
. $SCRIPT_DIR'/_pre.sh'
. $SCRIPT_DIR'/_results.sh'
. $SCRIPT_DIR'/_views.sh'

if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

AP_TEST_ARG=''
if [[ "$AP_TEST" = "true" ]] ; then
    AP_TEST_ARG='&test=true'
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
    districts & PIDDISTRICTS=$!
    wait $PIDDISTRICTS
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