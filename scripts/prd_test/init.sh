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

echo "Drop elex_$1 if it exists"
dropdb -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE --if-exists

echo "Create elex_$RACEDATE"
psql -l | grep -q elex_$RACEDATE || createdb -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE

echo "Initialize races"
psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "DROP TABLE IF EXISTS races CASCADE; CREATE TABLE races (
    id varchar,
    raceid varchar,
    racetype varchar,
    racetypeid varchar,
    description varchar,
    electiondate varchar,
    initialization_data boolean,
    lastupdated date,
    national boolean,
    officeid varchar,
    officename varchar,
    party varchar,
    seatname varchar,
    seatnum varchar,
    statename varchar,
    statepostal char(2),
    test boolean,
    uncontested boolean
);"

elex races $RACEDATE -t | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY races FROM stdin DELIMITER ',' CSV HEADER;"

echo "Initialize reporting units"
psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "DROP TABLE IF EXISTS reporting_units CASCADE; CREATE TABLE reporting_units(
    id varchar,
    reportingunitid varchar,
    reportingunitname varchar,
    description varchar,
    electiondate varchar,
    fipscode char(5),
    initialization_data bool,
    lastupdated date,
    level varchar,
    national varchar,
    officeid varchar,
    officename varchar,
    precinctsreporting integer,
    precinctsreportingpct numeric,
    precinctstotal integer,
    raceid varchar,
    racetype varchar,
    racetypeid varchar,
    seatname varchar,
    seatnum varchar,
    statename varchar,
    statepostal varchar,
    test bool,
    uncontested bool,
    votecount integer
);"

elex reporting-units $RACEDATE -t | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY reporting_units FROM stdin DELIMITER ',' CSV HEADER;"

echo "Initialize candidates"
psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "DROP TABLE IF EXISTS candidates CASCADE; CREATE TABLE candidates(
    id varchar,
    unique_id varchar,
    candidateid varchar,
    ballotorder integer,
    first varchar,
    last varchar,
    party varchar,
    polid varchar,
    polnum varchar
);"

elex candidates $RACEDATE -t | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY candidates FROM stdin DELIMITER ',' CSV HEADER;"

echo "Initialize ballot positions"
psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "DROP TABLE IF EXISTS ballot_positions CASCADE; CREATE TABLE ballot_positions(
    id varchar,
    unique_id varchar,
    candidateid varchar,
    ballotorder integer,
    description varchar,
    last varchar,
    polid varchar,
    polnum varchar,
    seatname varchar
);"

elex ballot-measures $RACEDATE -t | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY ballot_positions FROM stdin DELIMITER ',' CSV HEADER;"

echo "Create candidate overrides table"
psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "DROP TABLE IF EXISTS override_candidates CASCADE; CREATE TABLE override_candidates(
    candidate_candidateid varchar,
    nyt_candidate_name varchar,
    nyt_candidate_important bool,
    nyt_candidate_description varchar,
    nyt_races integer[]
);"

echo "Create race overrides table"
psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "DROP TABLE IF EXISTS override_races CASCADE; CREATE TABLE override_races(
    race_raceid varchar,
    nyt_race_name varchar,
    nyt_race_description varchar,
    accept_ap_calls bool,
    nyt_called bool,
    nyt_winner varchar,
    nyt_race_important bool
);"

psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY override_candidates FROM '`pwd`/overrides/candidate.csv' DELIMITER ',' CSV HEADER;"
psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY override_races FROM '`pwd`/overrides/race.csv' DELIMITER ',' CSV HEADER;"

echo "------------------------------"
date "+ENDED: %H:%M:%S"
