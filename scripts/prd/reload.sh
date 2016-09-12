#!/bin/bash

. /home/ubuntu/elex-loader/scripts/prd/_admin.sh
. /home/ubuntu/elex-loader/scripts/prd/_delegates.sh
. /home/ubuntu/elex-loader/scripts/prd/_districts.sh
. /home/ubuntu/elex-loader/scripts/prd/_init.sh
. /home/ubuntu/elex-loader/scripts/prd/_overrides.sh
. /home/ubuntu/elex-loader/scripts/prd/_post.sh
. /home/ubuntu/elex-loader/scripts/prd/_pre.sh
. /home/ubuntu/elex-loader/scripts/prd/_results.sh
. /home/ubuntu/elex-loader/scripts/prd/_views.sh

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

views
admin
post