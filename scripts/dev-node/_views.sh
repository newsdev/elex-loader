function views {
    cat node_modules/elex-loader/fields/elex_races.txt | psql elex_$RACEDATE
    cat node_modules/elex-loader/fields/elex_candidates.txt | psql elex_$RACEDATE
    cat node_modules/elex-loader/fields/elex_results.txt | psql elex_$RACEDATE
}