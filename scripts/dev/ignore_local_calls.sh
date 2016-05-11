#!/bin/bash

. scripts/dev/_racecalls.sh


if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

ignore_local_ap_calls