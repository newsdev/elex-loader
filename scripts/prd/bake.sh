#!/bin/bash
. /home/ubuntu/elex-loader/scripts/stg/_pre.sh
. /etc/environment

if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

pre
cd /home/ubuntu/election-2016/LATEST/ && npm run post-update "$RACEDATE"
