#!/bin/bash

SCRIPT_DIR=$(dirname $BASH_SOURCE)

function create_databases {
    while read racedate; do
        if psql -lqt | cut -d \| -f 1 | grep -qw elex_$racedate; then
            echo "elex_$racedate exists, skipping"
        else
            createdb elex_$racedate
            echo "created elex_$racedate"
        fi
    done <$SCRIPT_DIR'/../../racedates.txt'
}

function create_user {
    createuser -s elex > /dev/null 2>&1
}

create_user
create_databases