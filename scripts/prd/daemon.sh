#!/bin/bash

# set RACEDATE from the first argument, if it exists
if [[ ! -z $1 ]] ; then
    RACEDATE=$1
fi

if [[ -z $RACEDATE ]] ; then
    echo 'Provide a race date, such as 2016-02-01'
    exit 1
fi

if [[ -z "$AP_API_KEY" ]] ; then
    echo "Missing environmental variable AP_API_KEY. Try 'export AP_API_KEY=MY_API_KEY_GOES_HERE'."
    exit 1
fi

while [ 1 ]; do
    source /etc/environment && source /home/ubuntu/.virtualenvs/elex-loader/bin/activate && /bin/bash /home/ubuntu/elex-loader/scripts/stg/update.sh $RACEDATE
    export NODE_ENV="production" && cd /home/ubuntu/election-2016/ && npm run post-update $RACEDATE
    sleep 10
done
