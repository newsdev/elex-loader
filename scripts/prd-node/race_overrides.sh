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

cat node_modules/elex-loader/fields/race_overrides.txt | psql elex_$RACEDATE
cat node_modules/elex-loader/fields/elex_races.txt | psql elex_$RACEDATE
cat $OVERRIDE_DIR/$RACEDATE'_override_races.csv' | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY override_races FROM stdin DELIMITER ',' CSV HEADER;"