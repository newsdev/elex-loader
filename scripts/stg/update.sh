#!/bin/bash

# set RACEDATE from the first argument, if it exists
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

date "+STARTED: %H:%M:%S"
echo "------------------------------"

function drop_table
{
    psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "DROP TABLE IF EXISTS results CASCADE; CREATE TABLE results(
        id varchar,
        unique_id varchar,
        raceid varchar,
        racetype varchar,
        racetypeid varchar,
        ballotorder int,
        candidateid varchar,
        description varchar,
        electiondate varchar,
        fipscode char(5),
        first varchar,
        incumbent bool,
        initialization_data bool,
        is_ballot_position bool,
        last varchar,
        lastupdated varchar,
        level varchar,
        national bool,
        officeid varchar,
        officename varchar,
        party varchar,
        polid varchar,
        polnum varchar,
        precinctsreporting int,
        precinctsreportingpct numeric,
        precinctstotal int,
        reportingunitid varchar,
        reportingunitname varchar,
        runoff bool,
        seatname varchar,
        seatnum varchar,
        statename varchar,
        statepostal char(2),
        test bool,
        uncontested bool,
        votecount int,
        votepct numeric,
        winner bool
    );"
}

function get_results
{
    elex results $RACEDATE -t > results.csv
}

function load_results
{
    cat results.csv | psql elex_$RACEDATE -c "COPY results FROM stdin DELIMITER ',' CSV HEADER;"
}

function replace_views
{
    psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "CREATE OR REPLACE VIEW elex_races as
       SELECT o.*, r.* from races as r
           LEFT JOIN override_races as o on r.raceid = o.race_raceid
    ;"

    psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "CREATE OR REPLACE VIEW elex_results as
       SELECT o.*, c.*, r.* from results as r
           LEFT JOIN override_candidates as c on r.candidateid = c.candidate_candidateid
           LEFT JOIN override_races as o on r.raceid = o.race_raceid
    ;"

    psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "CREATE OR REPLACE VIEW elex_candidates as
       SELECT c.*, r.* from candidates as r
           LEFT JOIN override_candidates as c on r.candidateid = c.candidate_candidateid
    ;"
}

if get_results; then
    drop_table
    load_results
    replace_views
    rm -rf results.csv
else
    echo "ERROR: Bad response from AP. No results loaded."
    rm -rf results.csv
fi

echo "------------------------------"
date "+ENDED: %H:%M:%S"