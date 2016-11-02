function set_live_tables {
    cat $SCRIPT_DIR'/../../fields/results.txt' | psql elex_$RACEDATE
}

function set_temp_tables {
    cat $SCRIPT_DIR'/../../fields/results_temp.txt' | psql elex_$RACEDATE
}

function get_national_results {
    curl --compressed -o /tmp/results_national_$RACEDATE.json "http://api.ap.org/v2/elections/$RACEDATE?apiKey=$AP_NAT_KEY&format=json&level=ru&national=true$AP_TEST_ARG"
}

function get_local_results {
    curl --compressed -o /tmp/results_local_$RACEDATE.json "http://api.ap.org/v2/elections/$RACEDATE?apiKey=$AP_LOC_KEY&format=json&level=ru&national=false$AP_TEST_ARG"
}

function load_national_results {
    elex results $RACEDATE -t -d /tmp/results_national_$RACEDATE.json | psql elex_$RACEDATE -c "COPY results_temp FROM stdin DELIMITER ',' CSV HEADER;"
}

function load_local_results {
    elex results $RACEDATE -t -d /tmp/results_local_$RACEDATE.json | psql elex_$RACEDATE -c "COPY results_temp FROM stdin DELIMITER ',' CSV HEADER;"
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

function copy_results {
    psql elex_$RACEDATE -c "TRUNCATE results CASCADE; INSERT INTO results SELECT * FROM results_temp;"
}