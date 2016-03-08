function get_init {
    curl -o /tmp/results_$RACEDATE.json "http://api.ap.org/v2/elections/$RACEDATE?apiKey=$AP_API_KEY&format=json&level=ru&test=true&setzerocounts=true"
}

function load_init {
    cat /home/ubuntu/elex-loader/fields/races.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
    elex races $RACEDATE -d /tmp/results_$RACEDATE.json | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY races FROM stdin DELIMITER ',' CSV HEADER;"

    cat /home/ubuntu/elex-loader/fields/reporting_units.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
    elex reporting-units $RACEDATE -d /tmp/results_$RACEDATE.json | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY reporting_units FROM stdin DELIMITER ',' CSV HEADER;"

    cat /home/ubuntu/elex-loader/fields/candidates.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
    elex candidates $RACEDATE -d /tmp/results_$RACEDATE.json | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY candidates FROM stdin DELIMITER ',' CSV HEADER;"

    cat /home/ubuntu/elex-loader/fields/ballot_measures.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
    elex ballot-measures $RACEDATE -d /tmp/results_$RACEDATE.json | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY ballot_positions FROM stdin DELIMITER ',' CSV HEADER;"

    cat /home/ubuntu/elex-loader/fields/results.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE 
    elex results $RACEDATE -d /tmp/results_$RACEDATE.json | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY results FROM stdin DELIMITER ',' CSV HEADER;"
}

function init {
    if get_init; then
        load_init
    else
        echo "ERROR | INIT | Bad response. Did not load $RACEDATE."
    fi
}