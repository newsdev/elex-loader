function get_districts {
    elex results $RACEDATE --results-level district > /tmp/districts_$RACEDATE.csv
}

function load_districts {
    cat /tmp/districts_$RACEDATE.csv | grep 'Z,district,\|,lastupdated,level,national,' | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY results FROM stdin DELIMITER ',' CSV HEADER;"
}

function districts {
    if get_districts; then
        load_districts
    else
        echo "ERROR | DISTRICTS | Bad response. Did not load $RACEDATE."
    fi
}