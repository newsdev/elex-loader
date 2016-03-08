function overrides {
    cat /home/ubuntu/elex-loader/fields/race_overrides.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
    cat /home/ubuntu/elex-loader/fields/elex_races.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
    cat $OVERRIDE_DIR/$RACEDATE'_override_races.csv' | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY override_races FROM stdin DELIMITER ',' CSV HEADER;"
    cat /home/ubuntu/elex-loader/fields/candidate_overrides.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
    cat /home/ubuntu/elex-loader/fields/elex_candidates.txt | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE
    cat $OVERRIDE_DIR/$RACEDATE'_override_candidates.csv' | psql -h $ELEX_DB_HOST -U elex -d elex_$RACEDATE -c "COPY override_candidates FROM stdin DELIMITER ',' CSV HEADER;"
}