#!/bin/bash

. scripts/dev/_districts.sh
. scripts/dev/_init.sh
. scripts/dev/_overrides.sh
. scripts/dev/_post.sh
. scripts/dev/_pre.sh
. scripts/dev/_results.sh
. scripts/dev/_views.sh

if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

if [[ -z $OVERRIDE_DIR ]] ; then
    OVERRIDE_DIR='overrides'
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

districts
views
post