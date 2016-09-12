#!/bin/bash

# Get script location, so scripts work from this repo
# and when installed into Node modules
SCRIPT_DIR=$(dirname $BASH_SOURCE)

. $SCRIPT_DIR'/_pre.sh'
. $SCRIPT_DIR'/_overrides.sh'
. $SCRIPT_DIR'/_init.sh'
. $SCRIPT_DIR'/_districts.sh'
. $SCRIPT_DIR'/_delegates.sh'
. $SCRIPT_DIR'/_results.sh'
. $SCRIPT_DIR'/_views.sh'
. $SCRIPT_DIR'/_post.sh'

if [[ ! -z $1 ]] ; then
    RACEDATE=$1
fi

if [[ -z $OVERRIDE_DIR ]] ; then
    OVERRIDE_DIR='overrides'
fi

AP_TEST_ARG=''
if [[ "$AP_TEST" = "true" ]] ; then
    AP_TEST_ARG='&test=true'
fi

pre
overrides
init

set_db_tables

# Run local / national results in parallel.
# Will block the rest of the scripts until it's done.
local_results &  PIDLOCAL=$!
national_results &  PIDNATIONAL=$!
wait $PIDLOCAL
wait $PIDNATIONAL

# # Commenting out districts for now.
# districts
views
post
