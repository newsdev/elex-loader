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

echo "Create candidate overrides table"
psql elex_$RACEDATE -c "DROP TABLE IF EXISTS override_candidates CASCADE; CREATE TABLE override_candidates(
    candidate_candidateid varchar,
    nyt_candidate_name varchar,
    nyt_candidate_important bool,
    nyt_candidate_description text,
    nyt_races integer[],
    nyt_display_order int,
    nyt_winner bool
);"

echo "Create race overrides table"
psql elex_$RACEDATE -c "DROP TABLE IF EXISTS override_races CASCADE; CREATE TABLE override_races(
    nyt_race_preview text,
    nyt_race_result_description text,
    nyt_delegate_allocation text,
    report bool,
    report_description text,
    race_raceid varchar,
    nyt_race_name varchar,
    nyt_race_description text,
    accept_ap_calls bool,
    nyt_called bool,
    nyt_race_important bool
);"

echo "------------------------------"
date "+ENDED: %H:%M:%S"