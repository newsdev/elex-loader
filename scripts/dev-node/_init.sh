function get_national_init {
    curl -o /tmp/results_national_$RACEDATE.json "http://api.ap.org/v2/elections/$RACEDATE?apiKey=$AP_NAT_KEY&format=json&level=ru$AP_TEST_ARG&national=true"
}

function get_national_init {
    curl -o /tmp/results_local_$RACEDATE.json "http://api.ap.org/v2/elections/$RACEDATE?apiKey=$AP_LOC_KEY&format=json&level=ru$AP_TEST_ARG&national=false"
}

function load_init {
    cat $SCRIPT_DIR'/../../fields/races.txt' | psql elex_$RACEDATE
    elex races $RACEDATE -d /tmp/results_local_$RACEDATE.json | psql elex_$RACEDATE -c "COPY races FROM stdin DELIMITER ',' CSV HEADER;"
    elex races $RACEDATE -d /tmp/results_national_$RACEDATE.json | psql elex_$RACEDATE -c "COPY races FROM stdin DELIMITER ',' CSV HEADER;"

    cat $SCRIPT_DIR'/../../fields/reporting_units.txt' | psql elex_$RACEDATE
    elex reporting-units $RACEDATE -d /tmp/results_national_$RACEDATE.json | psql elex_$RACEDATE -c "COPY reporting_units FROM stdin DELIMITER ',' CSV HEADER;"
    elex reporting-units $RACEDATE -d /tmp/results_local_$RACEDATE.json | psql elex_$RACEDATE -c "COPY reporting_units FROM stdin DELIMITER ',' CSV HEADER;"

    cat $SCRIPT_DIR'/../../fields/candidates.txt' | psql elex_$RACEDATE
    elex candidates $RACEDATE -d /tmp/results_national_$RACEDATE.json | psql elex_$RACEDATE -c "COPY candidates FROM stdin DELIMITER ',' CSV HEADER;"
    elex candidates $RACEDATE -d /tmp/results_local_$RACEDATE.json | psql elex_$RACEDATE -c "COPY candidates FROM stdin DELIMITER ',' CSV HEADER;"

    cat $SCRIPT_DIR'/../../fields/ballot_measures.txt' | psql elex_$RACEDATE
    elex candidates $RACEDATE -d /tmp/results_national_$RACEDATE.json | psql elex_$RACEDATE -c "COPY candidates FROM stdin DELIMITER ',' CSV HEADER;"
    elex candidates $RACEDATE -d /tmp/results_local_$RACEDATE.json | psql elex_$RACEDATE -c "COPY candidates FROM stdin DELIMITER ',' CSV HEADER;"
}

function init {
    if [ get_national_init ] && [ get_local_init ] ; then
        load_init
    else
        echo "ERROR | INIT | Bad response. Did not load $RACEDATE."
    fi
}