#!/bin/bash

source config.sh

date "+STARTED: %H:%M:%S"
echo "------------------------------"

echo "Initialize races"
psql elex -c "DROP TABLE IF EXISTS races CASCADE; CREATE TABLE races (
    id varchar,
    raceid varchar,
    racetype varchar,
    racetypeid varchar,
    description varchar,
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

elex races $RACEDATE -t | psql elex -c "COPY races FROM stdin DELIMITER ',' CSV HEADER;"

echo "Initialize reporting units"
psql elex -c "DROP TABLE IF EXISTS reporting_units CASCADE; CREATE TABLE reporting_units(
    id varchar,
    reportingunitid varchar,
    reportingunitname varchar,
    description varchar,
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

elex reporting-units $RACEDATE -t | psql elex -c "COPY reporting_units FROM stdin DELIMITER ',' CSV HEADER;"

echo "Initialize candidates"
psql elex -c "DROP TABLE IF EXISTS candidates CASCADE; CREATE TABLE candidates(
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

elex candidates $RACEDATE -t | psql elex -c "COPY candidates FROM stdin DELIMITER ',' CSV HEADER;"

echo "Initialize ballot positions"
psql elex -c "DROP TABLE IF EXISTS ballot_positions CASCADE; CREATE TABLE ballot_positions(
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

elex ballot-measures $RACEDATE -t | psql elex -c "COPY ballot_positions FROM stdin DELIMITER ',' CSV HEADER;"

echo "Create candidate overrides table"
psql elex -c "DROP TABLE IF EXISTS override_candidates CASCADE; CREATE TABLE override_candidates(
    candidate_candidateid varchar,
    nyt_candidate_name varchar,
    nyt_candidate_important bool,
    nyt_candidate_description varchar,
    nyt_races integer[]
);"

echo "Create race overrides table"
psql elex -c "DROP TABLE IF EXISTS override_races CASCADE; CREATE TABLE override_races(
    race_raceid varchar,
    nyt_race_name varchar,
    nyt_race_description varchar,
    accept_ap_calls bool,
    nyt_called bool,
    nyt_winner varchar,
    nyt_race_important bool
);"

psql elex -c "COPY override_candidates FROM '`pwd`/overrides/candidate.csv' DELIMITER ',' CSV HEADER;"
psql elex -c "COPY override_races FROM '`pwd`/overrides/race.csv' DELIMITER ',' CSV HEADER;"

echo "------------------------------"
date "+ENDED: %H:%M:%S"
