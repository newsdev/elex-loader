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

date "+STARTED: %H:%M:%S"
echo "------------------------------"

psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "DROP TABLE IF EXISTS delegates CASCADE; CREATE TABLE delegates(
    level varchar,
    party_total integer,
    superdelegates_count integer,
    last varchar,
    state varchar,
    candidateid varchar,
    party_need integer,
    party varchar,
    delegates_count integer,
    id varchar
);"

elex delegates -t | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY delegates FROM stdin DELIMITER ',' CSV HEADER;"

echo "------------------------------"
date "+ENDED: %H:%M:%S"
