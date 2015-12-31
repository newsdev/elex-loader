#!/bin/bash

date "+STARTED: %H:%M:%S"
echo "------------------------------"

psql elex -c "DROP TABLE IF EXISTS results CASCADE; CREATE TABLE results(
    id varchar,
    unique_id varchar,
    raceid varchar,
    racetype varchar,
    racetypeid varchar,
    ballotorder int,
    candidateid varchar,
    description varchar,
    electiondate date,
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

elex results $RACEDATE -t | psql elex -c "COPY results FROM stdin DELIMITER ',' CSV HEADER;"

psql elex -c "CREATE OR REPLACE VIEW elex_races as
   SELECT o.*, r.* from races as r
       LEFT JOIN override_races as o on r.raceid = o.race_raceid
;"

psql elex -c "CREATE OR REPLACE VIEW elex_results as
   SELECT o.*, c.*, r.* from results as r
       LEFT JOIN override_candidates as c on r.candidateid = c.candidate_candidateid
       LEFT JOIN override_races as o on r.raceid = o.race_raceid
;"

psql elex -c "CREATE OR REPLACE VIEW elex_candidates as
   SELECT c.*, r.* from candidates as r
       LEFT JOIN override_candidates as c on r.candidateid = c.candidate_candidateid
;"

echo "------------------------------"
date "+ENDED: %H:%M:%S"
