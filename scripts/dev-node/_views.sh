function views {
    cat $SCRIPT_DIR'/../../fields/elex_races.txt' | psql elex_$RACEDATE
    cat $SCRIPT_DIR'/../../fields/elex_candidates.txt' | psql elex_$RACEDATE
    cat $SCRIPT_DIR'/../../fields/elex_results.txt' | psql elex_$RACEDATE
}