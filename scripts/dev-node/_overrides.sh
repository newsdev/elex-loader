function overrides {
    cat node_modules/elex-loader/fields/candidate_overrides.txt | psql elex_$RACEDATE
    cat node_modules/elex-loader/fields/elex_candidates.txt | psql elex_$RACEDATE
    cat $OVERRIDE_DIR/$RACEDATE'_override_candidates.csv' | psql elex_$RACEDATE -c "COPY override_candidates FROM stdin DELIMITER ',' CSV HEADER;"
    cat node_modules/elex-loader/fields/race_overrides.txt | psql elex_$RACEDATE
    cat node_modules/elex-loader/fields/elex_races.txt | psql elex_$RACEDATE
    cat $OVERRIDE_DIR/$RACEDATE'_override_races.csv' | psql elex_$RACEDATE -c "COPY override_races FROM stdin DELIMITER ',' CSV HEADER;"
}