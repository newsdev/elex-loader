#!/bin/bash

. scripts/stg/_admin.sh
. scripts/stg/_delegates.sh
. scripts/stg/_districts.sh
. scripts/stg/_init.sh
. scripts/stg/_overrides.sh
. scripts/stg/_post.sh
. scripts/stg/_pre.sh
. scripts/stg/_views.sh

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
admin
post