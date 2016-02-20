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

let w=30

for (( i=1; i<100000; i+=1 )); do

    let v=i%4

    if [ "$v" -eq 0 ]; then
        /home/ubuntu/elex-loader/scripts/stg/delegates.sh $RACEDATE
    else
        /home/ubuntu/elex-loader/scripts/stg/update.sh $RACEDATE
    fi

    cd /home/ubuntu/election-2016/LATEST/ && npm run post-update "$RACEDATE"

    sleep $w

done
