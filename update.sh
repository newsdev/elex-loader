#!/bin/bash

source config.sh

psql elex -c "DROP TABLE IF EXISTS results CASCADE; CREATE TABLE results(
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
echo "Create name_overrides table"
psql elex -c "DROP TABLE IF EXISTS name_overrides CASCADE; CREATE TABLE name_overrides(
    unique_id varchar,
    first varchar,
    last varchar
);"

psql elex -c "COPY name_overrides FROM '`pwd`/name_overrides.csv' DELIMITER ',' CSV HEADER;"

psql elex -c "CREATE OR REPLACE VIEW elex_results as
    SELECT n.last as display_last, n.first as display_first, r.* from results as r
        LEFT JOIN name_overrides as n on r.unique_id = n.unique_id
;"
