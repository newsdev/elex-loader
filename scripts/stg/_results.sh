function set_live_tables {
    cat fields/results.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
}

function set_temp_tables {
    cat fields/results_temp.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
}

function get_results {
    curl --compressed -f -o /tmp/results_national_$RACEDATE.json $AP_API_BASE_URL"/elections/$RACEDATE?apiKey=$AP_NAT_KEY&format=json&level=ru&test=true"  >/dev/null 2>&1
}

function get_districts {
    curl --compressed -f -o /tmp/results_district_$RACEDATE.json $AP_API_BASE_URL"/elections/$RACEDATE?apiKey=$AP_NAT_KEY&format=json&level=district&national=true&test=true"  >/dev/null 2>&1
}

function load_results {
    elex results $RACEDATE -t -d /tmp/results_national_$RACEDATE.json > /tmp/results_national_$RACEDATE.csv
    cat /tmp/results_national_$RACEDATE.csv | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY results_temp FROM stdin DELIMITER ',' CSV HEADER;"
}

function load_districts {
    elex results $RACEDATE -t -d /tmp/results_district_$RACEDATE.json | grep 'Z,district,\|,lastupdated,level,national,' | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY results_temp FROM stdin DELIMITER ',' CSV HEADER;"
}

function districts {
    if get_districts; then
        load_districts
    else
        echo "1" > /tmp/elex_error.txt
        echo 'ELEX LOADER error: Districts failed to download.'
    fi
}

function results {
    if get_results; then
        load_results
    else
        echo "1" > /tmp/elex_error.txt
        echo 'ELEX LOADER error: Results failed to download.'
    fi
}

function copy_results {
    psql elex_$RACEDATE -c "TRUNCATE results CASCADE; INSERT INTO results SELECT * FROM results_temp;"
}
