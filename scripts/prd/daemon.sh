#!/bin/bash

if [[ ! -z $1 ]] ; then
    RACEDATE=$1
fi

if [[ -z $RACEDATE ]] ; then
    echo 'Provide a race date, such as 2016-02-01'
    exit 1
fi

. /etc/environment
. /home/ubuntu/.virtualenvs/elex-loader/bin/activate

while true; do
    /home/ubuntu/elex-loader/scripts/prd/update.sh $RACEDATE
    /home/ubuntu/elex-loader/scripts/prd/delegates.sh $RACEDATE
    cd /home/ubuntu/election-2016/LATEST/
    npm run post-update "$RACEDATE"
    sleep 10
done
