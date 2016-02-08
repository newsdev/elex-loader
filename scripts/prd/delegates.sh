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

date "+STARTED: %H:%M:%S"
echo "------------------------------"

cat /home/ubuntu/elex-loader/fields/delgates.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
elex delegates | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY delegates FROM stdin DELIMITER ',' CSV HEADER;"

echo "------------------------------"
date "+ENDED: %H:%M:%S"