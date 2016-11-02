function get_districts {
    curl --compressed -o /tmp/results_district_$RACEDATE.json $AP_API_BASE_URL"elections/$RACEDATE?apiKey=$AP_NAT_KEY&format=json&level=district&national=true&test=true"
}

function load_districts {
    elex results $RACEDATE -t -d /tmp/results_district_$RACEDATE.json | psql elex_$RACEDATE -c "COPY results_temp FROM stdin DELIMITER ',' CSV HEADER;"
}

function districts {
    if get_districts; then
        load_districts
    else
        echo "ERROR | DISTRICTS | Bad response. Did not load $RACEDATE."
    fi
}