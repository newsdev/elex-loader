#!/bin/bash

. /home/ubuntu/elex-loader/scripts/stg/_delegates.sh
. /home/ubuntu/elex-loader/scripts/stg/_post.sh
. /home/ubuntu/elex-loader/scripts/stg/_pre.sh
. /home/ubuntu/elex-loader/scripts/stg/_views.sh

if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

pre
delegates
views
post