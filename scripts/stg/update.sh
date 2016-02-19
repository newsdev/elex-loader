#!/bin/bash
if [[ ! -z $1 ]] ; then
    RACEDATE=$1
fi

if [[ -z $RACEDATE ]] ; then
    echo 'Provide a race date, such as 2016-02-01'
    exit 1
fi

if [[ -z '$AP_API_KEY' ]] ; then
    echo "Missing environmental variable AP_API_KEY. Try 'export AP_API_KEY=MY_API_KEY_GOES_HERE'."
    exit 1
fi

function drop_table { 
    cat /home/ubuntu/elex-loader/fields/results.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE 
}

function get_results {
    elex results $RACEDATE -t > /tmp/results.csv
}

function load_results {
    cat /tmp/results.csv | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY results FROM stdin DELIMITER ',' CSV HEADER;"
}

function get_district_results {
    elex results $RACEDATE -t --results-level district > /tmp/district-results.csv
}

function load_district_results {
    # load only header and district-level results
    cat /tmp/district-results.csv | grep ',district,\|,level,' | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY results FROM stdin DELIMITER ',' CSV HEADER;"
}

function replace_views {
    cat /home/ubuntu/elex-loader/fields/elex_races.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
    cat /home/ubuntu/elex-loader/fields/elex_candidates.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
    cat /home/ubuntu/elex-loader/fields/elex_results.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
}

if get_results && get_district_results; then
    drop_table
    load_results
    load_district_results
    replace_views
    touch "/home/ubuntu/elex-admin/elex_admin/app.py"
    rm -rf /tmp/results.csv
    rm -rf /tmp/district-results.csv
else
    echo 'ERROR: Bad response from AP. No results loaded.'
    rm -rf /tmp/results.csv
    rm -rf /tmp/district-results.csv
fi