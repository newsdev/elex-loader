function overrides {
    cat fields/candidate_overrides.txt | psql elex_$RACEDATE
    # cat $OVERRIDE_DIR/$RACEDATE'_override_candidates.csv' | psql elex_$RACEDATE -c "COPY override_candidates FROM stdin DELIMITER ',' CSV HEADER;"
    cat fields/race_overrides.txt | psql elex_$RACEDATE
    # cat $OVERRIDE_DIR/$RACEDATE'_override_races.csv' | psql elex_$RACEDATE -c "COPY override_races FROM stdin DELIMITER ',' CSV HEADER;"
}