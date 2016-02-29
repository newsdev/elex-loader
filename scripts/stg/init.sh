#!/bin/bash
if [[ ! -z $1 ]] ; then
    RACEDATE=$1
fi

if [[ -z $RACEDATE ]] ; then
    echo 'Provide a race date, such as 2016-02-01'
    exit 1
fi

if [[ -z "$AP_API_KEY" ]] ; then
    echo "Missing environmental variable AP_API_KEY. Try 'export AP_API_KEY=MY_API_KEY_GOES_HERE'."
    exit 1
fi

function get_results {
    curl -o /tmp/init_$RACEDATE.json "http://api.ap.org/v2/elections/$RACEDATE?apiKey=$AP_API_KEY&format=json&level=ru&test=true&setzerocounts=true"
}

function stop_services {
    sudo service elex-admin-$RACEDATE stop
    sudo service election-2016 stop
    psql -h $ELEX_DB_HOST -U elexadmin -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='elex_2016-02-23';"
}

function drop_database {
    dropdb -h $ELEX_DB_HOST -U elexadmin elex_$RACEDATE --if-exists
}

function create_database {
psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -l | grep -q elex_$RACEDATE || createdb -h $ELEX_DB_HOST -U elexadmin elex_$RACEDATE && psql -h $ELEX_DB_HOST -U elexadmin -d elex_$RACEDATE -c "create extension hstore;"
}

function initialize_data {
    cat /home/ubuntu/elex-loader/fields/races.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
    elex races $RACEDATE -t -d /tmp/init_$RACEDATE.json | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY races FROM stdin DELIMITER ',' CSV HEADER;"

    cat /home/ubuntu/elex-loader/fields/reporting_units.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
    elex reporting-units $RACEDATE -t -d /tmp/init_$RACEDATE.json | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY reporting_units FROM stdin DELIMITER ',' CSV HEADER;"

    cat /home/ubuntu/elex-loader/fields/candidates.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
    elex candidates $RACEDATE -t -d /tmp/init_$RACEDATE.json | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY candidates FROM stdin DELIMITER ',' CSV HEADER;"

    cat /home/ubuntu/elex-loader/fields/ballot_measures.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
    elex ballot-measures $RACEDATE -t -d /tmp/init_$RACEDATE.json | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY ballot_positions FROM stdin DELIMITER ',' CSV HEADER;"

    cat /home/ubuntu/elex-loader/fields/results.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE 
    elex results $RACEDATE -t -d /tmp/init_$RACEDATE.json | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY results FROM stdin DELIMITER ',' CSV HEADER;"

    cat /home/ubuntu/elex-loader/fields/delegates.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
    elex delegates | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY delegates FROM stdin DELIMITER ',' CSV HEADER;"

    elex results $RACEDATE -t --results-level district | grep 'Z,district,\|,lastupdated,level,national,' | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY results FROM stdin DELIMITER ',' CSV HEADER;"
}

function start_services {
    sudo service elex-admin-$RACEDATE start
    sudo service election-2016 start
}

function clean_up {
    rm -rf /tmp/init_$RACEDATE.json
}

if get_results; then
    stop_services
    drop_database
    create_database
    initialize_data
    start_services
    touch "/home/ubuntu/elex-admin/elex_admin/app.py"
else
    echo "ERROR: Bad response from AP. Did not initialize $RACEDATE."
fi

clean_up