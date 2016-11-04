function overrides {
    cat /home/ubuntu/elex-loader/fields/candidate_overrides.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
    cat /home/ubuntu/elex-loader/fields/race_overrides.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
}