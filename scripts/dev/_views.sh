function views {
    cat fields/elex_races.txt | psql elex_$RACEDATE
    cat fields/elex_candidates.txt | psql elex_$RACEDATE
    cat fields/elex_results.txt | psql elex_$RACEDATE
}