function accept_national_ap_calls {
    psql elex_$RACEDATE -c "UPDATE override_races o set accept_ap_calls = True from elex_races e WHERE o.race_raceid=e.race_raceid and e.officeid in ('H','S','G');"
}

function ignore_national_ap_calls {
    psql elex_$RACEDATE -c "UPDATE override_races o set accept_ap_calls = False from elex_races e WHERE o.race_raceid=e.race_raceid and e.officeid in ('H','S','G');"
}

function accept_local_ap_calls {
    psql elex_$RACEDATE -c "UPDATE override_races o set accept_ap_calls = True from elex_races e WHERE o.race_raceid=e.race_raceid and not(e.officeid in ('H','S','G','P'));"
}

function ignore_local_ap_calls {
    psql elex_$RACEDATE -c "UPDATE override_races o set accept_ap_calls = False from elex_races e WHERE o.race_raceid=e.race_raceid and not(e.officeid in ('H','S','G','P'));"
}