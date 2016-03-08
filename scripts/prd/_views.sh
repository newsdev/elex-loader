function views {
    cat /home/ubuntu/elex-loader/fields/elex_races.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
    cat /home/ubuntu/elex-loader/fields/elex_candidates.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
    cat /home/ubuntu/elex-loader/fields/elex_results.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
}