#!/bin/sh

RACEDATE=$1

if [[ $RACEDATE -eq 0 ]] ; then
    echo 'Provide a race date, such as 2016-02-01'
    exit 1
fi


while [ 1 ]; do
    ./update.sh $RACEDATE
    sleep 30
done
