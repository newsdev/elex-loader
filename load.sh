#!/bin/bash

RACEDATE="2015-11-03"

psql elex -c "DROP TABLE IF EXISTS races; CREATE TABLE races (
    description varchar,
    initialization_data boolean,
    lastupdated date,
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

