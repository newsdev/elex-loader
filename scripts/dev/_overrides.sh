function overrides {
    cat fields/candidate_overrides.txt | psql elex_$RACEDATE
    cat fields/race_overrides.txt | psql elex_$RACEDATE
}