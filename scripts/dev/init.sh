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

function get_results {
    curl -o /tmp/init_$RACEDATE.json "http://api.ap.org/v2/elections/$RACEDATE?apiKey=$AP_API_KEY&format=json&level=ru&test=true&setzerocounts=true"
}

function drop_database {
    dropdb elex_$RACEDATE --if-exists
}

function create_database {
    createdb elex_$RACEDATE && psql -d elex_$RACEDATE -c "create extension hstore;"
}

function initialize_data {

    cat fields/races.txt | psql elex_$RACEDATE
    elex races $RACEDATE -d /tmp/init_$RACEDATE.json | psql elex_$RACEDATE -c "COPY races FROM stdin DELIMITER ',' CSV HEADER;"

    cat fields/reporting_units.txt | psql elex_$RACEDATE
    elex reporting-units $RACEDATE -d /tmp/init_$RACEDATE.json | psql elex_$RACEDATE -c "COPY reporting_units FROM stdin DELIMITER ',' CSV HEADER;"

    cat fields/candidates.txt | psql elex_$RACEDATE
    elex candidates $RACEDATE -d /tmp/init_$RACEDATE.json | psql elex_$RACEDATE -c "COPY candidates FROM stdin DELIMITER ',' CSV HEADER;"

    cat fields/ballot_measures.txt | psql elex_$RACEDATE
    elex ballot-measures $RACEDATE -d /tmp/init_$RACEDATE.json | psql elex_$RACEDATE -c "COPY ballot_positions FROM stdin DELIMITER ',' CSV HEADER;"

    cat fields/delegates.txt | psql elex_$RACEDATE
    elex delegates | psql elex_$RACEDATE -c "COPY delegates FROM stdin DELIMITER ',' CSV HEADER;"

}


function clean_up {
    rm -rf /tmp/init_$RACEDATE.json
}

if get_results; then
    drop_database
    create_database
    initialize_data
else
    echo "ERROR: Bad response from AP. Did not initialize $RACEDATE."
fi

clean_up