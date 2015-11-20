#!/bin/bash

source config.sh

psql elex -c "DROP TABLE IF EXISTS results CASCADE; CREATE TABLE results(
    id varchar,
    unique_id varchar,
    raceid varchar,
    racetype varchar,
    racetypeid varchar,
    ballotorder int,
    candidateid varchar,
    description varchar,
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

elex results $RACEDATE | psql elex -c "COPY results FROM stdin DELIMITER ',' CSV HEADER;"

## THIS SHOULD MATCH YOUR `name_overrides.csv`
echo "Create overrides table"
psql elex -c "DROP TABLE IF EXISTS candidate_overrides CASCADE; CREATE TABLE candidate_overrides(
    unique_id varchar,
    nyt_name varchar,
    nyt_description varchar
);"

psql elex -c "COPY candidate_overrides FROM '`pwd`/candidate_overrides.csv' DELIMITER ',' CSV HEADER;"

psql elex -c "CREATE OR REPLACE VIEW elex_results as
    SELECT n.nyt_name as nyt_name, n.nyt_description as nyt_description, r.* from results as r
        LEFT JOIN candidate_overrides as n on r.unique_id = n.unique_id
;"
