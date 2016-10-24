#!/bin/bash
. /home/ubuntu/elex-loader/scripts/prd/_districts.sh
. /home/ubuntu/elex-loader/scripts/prd/_post.sh
. /home/ubuntu/elex-loader/scripts/prd/_pre.sh
. /home/ubuntu/elex-loader/scripts/prd/_results.sh
. /home/ubuntu/elex-loader/scripts/prd/_views.sh
. /etc/environment

if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

TIMESTAMP=$(date +"%s")

pre
set_db_tables

local_results & PIDLOCAL=$!
national_results & PIDNATIONAL=$!
districts & PIDDISTRICTS=$!
wait $PIDDISTRICTS
wait $PIDLOCAL
wait $PIDNATIONAL

views
post