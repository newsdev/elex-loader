function get_national_init {
    curl --compressed -o /tmp/results_national_$RACEDATE.json $AP_API_BASE_URL"elections/$RACEDATE?apiKey=$AP_NAT_KEY&format=json&level=ru&test=true&national=true"
}

function get_local_init {
    curl --compressed -o /tmp/results_local_$RACEDATE.json $AP_API_BASE_URL"elections/$RACEDATE?apiKey=$AP_LOC_KEY&format=json&level=ru&test=true&national=false"
}

function load_init {
    cat fields/races.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
    elex races $RACEDATE -d /tmp/results_local_$RACEDATE.json | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY races FROM stdin DELIMITER ',' CSV HEADER;"
    elex races $RACEDATE -d /tmp/results_national_$RACEDATE.json | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY races FROM stdin DELIMITER ',' CSV HEADER;"

    cat fields/reporting_units.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
    elex reporting-units $RACEDATE -d /tmp/results_national_$RACEDATE.json | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY reporting_units FROM stdin DELIMITER ',' CSV HEADER;"
    elex reporting-units $RACEDATE -d /tmp/results_local_$RACEDATE.json | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY reporting_units FROM stdin DELIMITER ',' CSV HEADER;"

    cat fields/candidates.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
    elex candidates $RACEDATE -d /tmp/results_national_$RACEDATE.json | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY candidates FROM stdin DELIMITER ',' CSV HEADER;"
    elex candidates $RACEDATE -d /tmp/results_local_$RACEDATE.json | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY candidates FROM stdin DELIMITER ',' CSV HEADER;"

    cat fields/ballot_measures.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
    elex ballot-measures $RACEDATE -d /tmp/results_national_$RACEDATE.json | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY ballot_positions FROM stdin DELIMITER ',' CSV HEADER;"
    elex ballot-measures $RACEDATE -d /tmp/results_local_$RACEDATE.json | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY ballot_positions FROM stdin DELIMITER ',' CSV HEADER;"

    cat fields/race_overrides.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
    cat fields/candidate_overrides.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
}

function init {
    if get_national_init && get_local_init ; then
        load_init
    else
        echo "ERROR | INIT | Bad response. Did not load $RACEDATE."
    fi
}

