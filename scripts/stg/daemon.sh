#!/bin/bash

if [[ ! -z $1 ]] ; then
    RACEDATE=$1
fi

if [[ -z $RACEDATE ]] ; then
    echo 'Provide a race date, such as 2016-02-01'
    exit 1
fi

source '/etc/environment'
source '/home/ubuntu/.virtualenvs/elex-loader/bin/activate'
cd '/home/ubuntu/election-2016/' || exit

while true; do
    /home/ubuntu/elex-loader/scripts/stg/update.sh "$RACEDATE"
    /home/ubuntu/elex-loader/scripts/stg/delegates.sh "$RACEDATE"
    npm run post-update "$RACEDATE"
    sleep 30
done
