#!/bin/bash

. scripts/dev/_delegates.sh
. scripts/dev/_post.sh
. scripts/dev/_pre.sh
. scripts/dev/_views.sh

if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

pre
delegates
views
post