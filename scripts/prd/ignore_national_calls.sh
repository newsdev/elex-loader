#!/bin/bash

. scripts/stg/_racecalls.sh


if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

ignore_national_ap_calls