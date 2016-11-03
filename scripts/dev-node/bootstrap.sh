#!/bin/bash

SCRIPT_DIR=$(dirname $BASH_SOURCE)

. $SCRIPT_DIR'/_pre.sh'
. $SCRIPT_DIR'/_overrides.sh'
. $SCRIPT_DIR'/_init.sh'
. $SCRIPT_DIR'/_districts.sh'
. $SCRIPT_DIR'/_results.sh'
. $SCRIPT_DIR'/_views.sh'
. $SCRIPT_DIR'/_post.sh'

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

set_live_tables
overrides
