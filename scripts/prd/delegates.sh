#!/bin/bash

. /home/ubuntu/elex-loader/scripts/prd/_delegates.sh
. /home/ubuntu/elex-loader/scripts/prd/_post.sh
. /home/ubuntu/elex-loader/scripts/prd/_pre.sh
. /home/ubuntu/elex-loader/scripts/prd/_views.sh

if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

pre
delegates
views
post