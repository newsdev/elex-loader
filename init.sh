#!/bin/bash

source config.sh

echo "Initialize races"
psql elex -c "DROP TABLE IF EXISTS races; CREATE TABLE races (
    description varchar,
    initialization_data boolean,
    lastupdated date,
    lastupdated_parsed varchar,
    national boolean,
    officeid varchar,
    officename varchar,
    party varchar,
    raceid varchar,
    racetype varchar,
    racetypeid varchar,
    seatname varchar,
    seatnum varchar,
    statename varchar,
    statepostal char(2),
    test boolean,
    uncontested boolean
);"

elex init-races $RACEDATE | psql elex -c "COPY races FROM stdin DELIMITER ',' CSV HEADER;"

echo "Initialize reporting units"
psql elex -c "DROP TABLE IF EXISTS reporting_units; CREATE TABLE reporting_units(
    description varchar,
    fipscode char(5),
    initialization_data boolean,
    lastupdated date,
    lastupdated_parsed date,
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
    reportingunitid varchar,
    reportingunitname varchar,
    seatname varchar,
    seatnum varchar,
    statename varchar,
    statepostal char(2),
    test boolean,
    uncontested varchar
);"

elex init-reporting-units $RACEDATE | psql elex -c "COPY reporting_units FROM stdin DELIMITER ',' CSV HEADER;"

echo "Initialize candidates"
psql elex -c "DROP TABLE IF EXISTS candidates; CREATE TABLE candidates(
    ballotorder int,
    candidateid int,
    first varchar,
    last varchar,
    party varchar,
    polid varchar,
    polnum varchar
);"

elex init-candidates $RACEDATE | psql elex -c "COPY candidates FROM stdin DELIMITER ',' CSV HEADER;"

echo "Initialize ballot positions"
psql elex -c "DROP TABLE IF EXISTS ballot_positions; CREATE TABLE ballot_positions(
    ballotorder int,
    candidateid int,
    description varchar,
    last varchar,
    polid varchar,
    polnum varchar,
    seatname varchar
);"

elex init-ballot-positions $RACEDATE | psql elex -c "COPY ballot_positions FROM stdin DELIMITER ',' CSV HEADER;"

psql elex -c "CREATE TABLE name_overrides(
    candidateid int,
    first varchar,
    last varchar
);"
