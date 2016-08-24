#!/bin/bash

. scripts/stg/_racecalls.sh


if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

ignore_prez_ap_calls