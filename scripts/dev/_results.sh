function set_db_tables {
    cat fields/local_results.txt | psql elex_$RACEDATE 
    cat fields/national_results.txt | psql elex_$RACEDATE 
}

function get_national_results {
    curl --compressed -o /tmp/results_national_$RACEDATE.json "http://api.ap.org/v2/elections/$RACEDATE?apiKey=$AP_NAT_KEY&format=json&level=ru&national=true&setZeroCounts=true"
}

function get_local_results {
    curl --compressed -o /tmp/results_local_$RACEDATE.json "http://api.ap.org/v2/elections/$RACEDATE?apiKey=$AP_LOC_KEY&format=json&level=ru&national=false&setZeroCounts=true"
}

function load_national_results {
    elex results $RACEDATE -t -d /tmp/results_national_$RACEDATE.json | psql elex_$RACEDATE -c "COPY national_results FROM stdin DELIMITER ',' CSV HEADER;"
}

function load_local_results {
    elex results $RACEDATE -t -d /tmp/results_local_$RACEDATE.json | psql elex_$RACEDATE -c "COPY local_results FROM stdin DELIMITER ',' CSV HEADER;"
}

function local_results {
    if get_local_results; then
        load_local_results
    else
        echo "ERROR | LOCAL RESULTS | Bad response. Did not load $RACEDATE."
    fi
}

function national_results {
    if get_national_results; then
        load_national_results
    else
        echo "ERROR | NATIONAL RESULTS | Bad response. Did not load $RACEDATE."
    fi
}