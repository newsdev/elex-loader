#!/bin/bash

. /home/ubuntu/elex-loader/scripts/stg/_districts.sh
. /home/ubuntu/elex-loader/scripts/stg/_post.sh
. /home/ubuntu/elex-loader/scripts/stg/_pre.sh
. /home/ubuntu/elex-loader/scripts/stg/_results.sh
. /home/ubuntu/elex-loader/scripts/stg/_views.sh

if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

pre
set_db_tables

# # Run local / national results in parallel.
# # Will block the rest of the scripts until it's done.
local_results & PIDLOCAL=$!
national_results & PIDNATIONAL=$!
wait $PIDLOCAL
wait $PIDNATIONAL

# # Commenting out districts for now.
# districts

views
post