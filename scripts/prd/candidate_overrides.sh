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

if [[ -z $OVERRIDE_DIR ]] ; then
    OVERRIDE_DIR='home/ubuntu/elex-loader/overrides'
fi

date "+STARTED: %H:%M:%S"
echo "------------------------------"

echo "Create candidate overrides table"
cat /home/ubuntu/elex-loader/fields/candidate_overrides.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
cat /home/ubuntu/elex-loader/fields/elex_candidates.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE

echo "Copy overrides file"
cat $OVERRIDE_DIR/$RACEDATE'_override_candidates.csv' | psql elex_$RACEDATE -c "COPY override_candidates FROM stdin DELIMITER ',' CSV HEADER;"

echo "------------------------------"
date "+ENDED: %H:%M:%S"