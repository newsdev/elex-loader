function get_delegates {
    elex delegates > /tmp/dels_$RACEDATE.csv
}

function load_delegates {
    cat fields/delegates.txt | psql elex_$RACEDATE
    cat /tmp/dels_$RACEDATE.csv | psql elex_$RACEDATE -c "COPY delegates FROM stdin DELIMITER ',' CSV HEADER;"
}

function delegates {
    if get_delegates; then
        load_delegates
    else
        echo "ERROR | DELEGATES | Bad response. Did not load $RACEDATE."
    fi
}