#!/bin/bash

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

./scripts/dev/init.sh $RACEDATE
./scripts/dev/race_overrides.sh $RACEDATE
./scripts/dev/candidate_overrides.sh $RACEDATE
./scripts/dev/update.sh $RACEDATE