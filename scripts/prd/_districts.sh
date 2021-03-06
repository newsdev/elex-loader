function get_districts {
    curl --compressed -o /tmp/results_district_$RACEDATE.json $AP_API_BASE_URL"elections/$RACEDATE?apiKey=$AP_NAT_KEY&format=json&level=district&national=true"
    cp /tmp/results_district_$RACEDATE.json /tmp/$RACEDATE/districts/ap_elections_loader_recording-NATIONAL-$TIMESTAMP.json
}

function load_districts {
    elex results $RACEDATE -t -d /tmp/results_district_$RACEDATE.json | grep 'Z,district,\|,lastupdated,level,national,' | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY results_temp FROM stdin DELIMITER ',' CSV HEADER;"
}

function districts {
    if get_districts; then
        load_districts
    else
        echo "ERROR | DISTRICTS | Bad response. Did not load $RACEDATE."
    fi
}