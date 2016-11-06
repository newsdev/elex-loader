#!/bin/bash

# Get script location, so scripts work from this repo
# and when installed into Node modules
SCRIPT_DIR=$(dirname $BASH_SOURCE)

. $SCRIPT_DIR'/_pre.sh'
. $SCRIPT_DIR'/_results.sh'
. $SCRIPT_DIR'/_districts.sh'
. $SCRIPT_DIR'/_views.sh'
. $SCRIPT_DIR'/_post.sh'

if [[ ! -z $1 ]] ; then
    RACEDATE=$1
fi

AP_TEST_ARG=''
if [[ "$AP_TEST" = "true" ]] ; then
    AP_TEST_ARG='&test=true'
fi

if [[ -z $AP_API_BASE_URL ]] ; then
    AP_API_BASE_URL="http://api.ap.org/v2/"
fi

pre
set_temp_tables

local_results & PIDLOCAL=$!
national_results & PIDNATIONAL=$!
districts & PIDDISTRICTS=$!
wait $PIDDISTRICTS
wait $PIDLOCAL
wait $PIDNATIONAL

copy_results
views
post
