#!/bin/bash

source config.sh

psql elex -c "DROP TABLE IF EXISTS results CASCADE; CREATE TABLE results(
    ballotorder int,
    candidateid int,
    description varchar,
    fipscode char(5),
    first varchar,
    incumbent boolean,
    initialization_data boolean,
    is_ballot_position boolean,
    last varchar,
    lastupdated date,
    level varchar,
    national boolean,
    officeid varchar,
    officename varchar,
    party varchar,
    polid varchar,
    polnum varchar,
    precinctsreporting int,
    precinctsreportingpct numeric,
    precinctstotal int,
    raceid varchar,
    racetype varchar,
    racetypeid varchar,
    reportingunitid varchar,
    reportingunitname varchar,
    seatname varchar,
    seatnum varchar,
    statename varchar,
    statepostal varchar,
    test boolean,
    uncontested boolean,
    votecount int,
    votepct numeric,
    winner boolean
);"

elex results $RACEDATE | psql elex -c "COPY results FROM stdin DELIMITER ',' CSV HEADER;"

psql elex -c "DROP TABLE IF EXISTS name_overrides; CREATE TABLE name_overrides(
    candidateid int,
    first varchar,
    last varchar
);"

psql elex -c "COPY name_overrides FROM '`pwd`/name_overrides.csv' DELIMITER ',' CSV HEADER;"

psql elex -c "CREATE OR REPLACE VIEW npr_results as
    SELECT n.last as display_last, n.first as display_first, r.* from results as r
        LEFT JOIN name_overrides as n on r.candidateid = n.candidateid
;"
