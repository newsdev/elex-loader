function get_results {
    curl -o /tmp/results_$RACEDATE.json "http://int-elex-stg-east.newsdev.net/elections/2016/deja-vu/elections/$RACEDATE?apiKey=$AP_API_KEY&format=json&level=ru&test=true"
}

function load_results {
    cat /home/ubuntu/elex-loader/fields/results.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE 
    elex results $RACEDATE -t -d /tmp/results_$RACEDATE.json | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY results FROM stdin DELIMITER ',' CSV HEADER;"
}

function results {
    timestamp=$(date +"%T")
    if get_results; then
        load_results
        cp /tmp/results_$RACEDATE.json /tmp/$RACEDATE/ap_elections_loader_recording-$timestamp.json
    else
        echo "ERROR | RESULTS | Bad response. Did not load $RACEDATE."
    fi
}
