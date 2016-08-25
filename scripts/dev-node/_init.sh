function get_init {
    curl -o /tmp/results_$RACEDATE.json "http://api.ap.org/v2/elections/$RACEDATE?apiKey=$AP_API_KEY&format=json&level=ru$AP_TEST_ARG&setzerocounts=true"
}

function load_init {
    cat $SCRIPT_DIR'/../../fields/races.txt' | psql elex_$RACEDATE
    elex races $RACEDATE -d /tmp/results_$RACEDATE.json | psql elex_$RACEDATE -c "COPY races FROM stdin DELIMITER ',' CSV HEADER;"

    cat $SCRIPT_DIR'/../../fields/reporting_units.txt' | psql elex_$RACEDATE
    elex reporting-units $RACEDATE -d /tmp/results_$RACEDATE.json | psql elex_$RACEDATE -c "COPY reporting_units FROM stdin DELIMITER ',' CSV HEADER;"

    cat $SCRIPT_DIR'/../../fields/candidates.txt' | psql elex_$RACEDATE
    elex candidates $RACEDATE -d /tmp/results_$RACEDATE.json | psql elex_$RACEDATE -c "COPY candidates FROM stdin DELIMITER ',' CSV HEADER;"

    cat $SCRIPT_DIR'/../../fields/ballot_measures.txt' | psql elex_$RACEDATE
    elex ballot-measures $RACEDATE -d /tmp/results_$RACEDATE.json | psql elex_$RACEDATE -c "COPY ballot_positions FROM stdin DELIMITER ',' CSV HEADER;"

    cat $SCRIPT_DIR'/../../fields/results.txt' | psql elex_$RACEDATE 
    elex results $RACEDATE -d /tmp/results_$RACEDATE.json | psql elex_$RACEDATE -c "COPY results FROM stdin DELIMITER ',' CSV HEADER;"
}

function init {
    if get_init; then
        load_init
    else
        echo "ERROR | INIT | Bad response. Did not load $RACEDATE."
    fi
}