#!/bin/bash
. /home/ubuntu/elex-loader/scripts/stg/_pre.sh
. /etc/environment

if [[ ! -z $1 ]] ; then
    RACEDATE=$1
fi

pre
echo $(readlink -f /home/ubuntu/election-2017/LATEST/)
cd /home/ubuntu/election-2017/LATEST/ && npm run post-update "$RACEDATE"
