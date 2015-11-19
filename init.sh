#!/bin/bash

source config.sh

echo "Initialize races"
psql elex -c "DROP TABLE IF EXISTS races CASCADE; CREATE TABLE races (
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

elex races $RACEDATE | psql elex -c "COPY races FROM stdin DELIMITER ',' CSV HEADER;"

echo "Initialize reporting units"
psql elex -c "DROP TABLE IF EXISTS reporting_units CASCADE; CREATE TABLE reporting_units(
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
    precinctsreporting int,
    precinctsreportingpct numeric,
    precinctstotal int,
    raceid varchar,
    racetype varchar,
    racetypeid varchar,
    seatname varchar,
    seatnum varchar,
    statename varchar,
    statepostal varchar,
    test bool,
    uncontested bool,
    votecount int
);"

elex reporting-units $RACEDATE | psql elex -c "COPY reporting_units FROM stdin DELIMITER ',' CSV HEADER;"

echo "Initialize candidates"
psql elex -c "CREATE TABLE candidates(
    unique_id varchar,
    candidateid varchar,
    ballotorder int,
    first varchar,
    last varchar,
    party varchar,
    polid varchar,
    polnum varchar
);"

elex candidates $RACEDATE | psql elex -c "DROP TABLE IF EXISTS candidates CASCADE; COPY candidates FROM stdin DELIMITER ',' CSV HEADER;"

echo "Initialize ballot positions"
psql elex -c "DROP TABLE IF EXISTS ballot_positions CASCADE; CREATE TABLE ballot_positions(
    unique_id varchar,
    candidateid varchar,
    ballotorder int,
    description varchar,
    last varchar,
    polid varchar,
    polnum varchar,
    seatname varchar
);"

elex ballot-positions $RACEDATE | psql elex -c "COPY ballot_positions FROM stdin DELIMITER ',' CSV HEADER;"
